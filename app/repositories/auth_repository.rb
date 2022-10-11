# frozen_string_literal: true

ACCOUNT_COUMNS = %w[username email phone phone_number]

class AuthRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @params = params
    @collection = Ibrain.user_class
  end

  def create
    user = collection.new(provider: 'manual')
    user.assign_attributes(normalize_params.except(:id_token))
    user.save!

    user
  end

  def sign_in
    return firebase_verify if is_social?

    user = collection.ibrain_find(manual_params, available_columns)
    return unless user.try(:valid_password?, manual_params[:password])

    user
  end

  private

  attr_reader :params, :collection

  def firebase_url
    "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{firebase_api_key}"
  end

  def firebase_update_url
    "https://identitytoolkit.googleapis.com/v1/accounts:update?key=#{firebase_api_key}"
  end

  def firebase_api_key
    Ibrain::Auth::Config.firebase_api_key
  end

  def base_headers
    {
      'Content-Type' => 'application/json'
    }
  end

  def normalize_params
    params.permit(permitted_attributes)
  end

  def manual_params
    params.permit(:username, :password)
  end

  def firebase_verify
    response = HTTParty.post(firebase_url, headers: base_headers, body: { 'idToken' => normalize_params[:id_token] }.to_json )
    user_information = response.try(:fetch, 'users', []).try(:at, 0)

    uid = user_information.try(:fetch, 'localId', nil)
    provider = user_information.
      try(:fetch, 'providerUserInfo', []).
      try(:at, 0).try(:fetch, 'providerId', '').
      try(:gsub, '.com', '')
    raise ActiveRecord::RecordNotFound, I18n.t('ibrain.errors.account.not_found') if uid.blank?

    collection.social_find_or_initialize({
      uid: uid,
      provider: provider,
      remote_avatar_url: user_information.try(:fetch, 'photoUrl', nil),
      email: user_information.try(:fetch, 'email', nil),
      password: 'Eco@123456'
    })
  end

  def available_columns
    collection.column_names.select { |f| ACCOUNT_COUMNS.include?(f) }
  end

  def is_social?
    normalize_params[:id_token].present?
  end

  def permitted_attributes
    Ibrain.user_class.permitted_attributes.reject { |k| permintted_columns.include?(k) }.map(&:to_sym).concat([:id_token])
  end

  def permintted_columns
    %w[
      reset_password_token reset_password_sent_at
      remember_created_at sign_in_count uid jti
      current_sign_in_at last_sign_in_at current_sign_in_ip
      last_sign_in_ip role encrypted_password id_token
    ]
  end
end
