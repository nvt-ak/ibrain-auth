# frozen_string_literal: true

ACCOUNT_COUMNS = %w[username email phone phone_number]

class AuthRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @params = params
    @collection = Ibrain.user_class
  end

  def create
    user = is_sso? ? sso_verify : collection.ibrain_find(manual_params, available_columns)
    user.assign_attributes(normalize_params.except(:id_token))
    user.save

    user
  end

  def sign_in
    return sso_verify if is_sso?

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
    params.require(:auth).permit(permitted_attributes)
  end

  def manual_params
    params.require(:auth).permit(:username, :password)
  end

  def sso_verify
    response = HTTParty.post(firebase_url, headers: base_headers, body: { 'idToken' => normalize_params[:id_token] }.to_json )
    user_information = response.try(:fetch, 'users', []).try(:at, 0)

    uid = user_information.try(:fetch, 'localId', nil)
    raise ActiveRecord::RecordNotFound, I18n.t('ibrain.errors.account.not_found') if uid.blank?

    collection.find_by(uid: uid)
  end

  def available_columns
    collection.column_names.select { |f| ACCOUNT_COUMNS.include?(f) }
  end

  def is_sso?
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
      last_sign_in_ip role encrypted_password
    ]
  end
end
