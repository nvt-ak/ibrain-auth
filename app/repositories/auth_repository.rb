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
    user.assign_attributes(normalize_params)
    user.save

    user
  end

  def sign_in
    user = is_sso? ? sso_verify : collection.ibrain_find(manual_params, available_columns)

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
    params.require(:auth).permit(:id_token)
  end

  def manual_params
    params.require(:auth).permit(:username, :password)
  end

  def sso_verify
    response = HTTParty.post(url, headers: base_headers, body: { 'idToken' => normalize_params[:id_token] }.to_json )
    uid = response.try(:fetch, 'users', []).try(:at, 0).try(:fetch, 'localId', nil)

    raise ActiveRecord::NotFound, I18n.t('ibrain.errors.account.not_found') if uid.blank?

    collection.find_by(uid: uid)
  end

  def available_columns
    collection.column_names.select { |f| ACCOUNT_COUMNS.include?(f) }
  end

  def is_sso?
    normalize_params[:id_token].present?
  end
end
