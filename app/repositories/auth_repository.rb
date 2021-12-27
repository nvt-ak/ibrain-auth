# frozen_string_literal: true

ACCOUNT_COUMNS = %w[username email phone phone_number]

class AuthRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @params = params
  end

  def create
    user = sso_verify if normalize_params[:id_token].present?

    if manual_params[:username].present?
      query = available_columns.map do |column_name|
        <<~RUBY
          #{column_name} = '#{manual_params[:username]}'
        RUBY
      end.join('OR')

      user = Ibrain.user_class.where(query).first
    end

    user.assign_attributes(normalize_params)
    user.save

    user
  end

  def sign_in
    return sso_verify if normalize_params[:id_token].present?

    user = Ibrain.user_class.where(
      'username = ? or email = ?',
      manual_params[:username],
      manual_params[:username]
    ).first

    return unless user.try(:valid_password?, manual_params[:password])

    user
  end

  private

  attr_reader :params

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

    Ibrain.user_class.find_by(uid: uid)
  end

  def available_columns
    Ibrain.user_class.column_names.select { |f| ACCOUNT_COUMNS.include?(f) }
  end
end
