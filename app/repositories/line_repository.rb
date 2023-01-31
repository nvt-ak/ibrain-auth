# frozen_string_literal: true

class LineRepository
  LINE_BASE_HEADERS = {
    'Content-Type': "application/x-www-form-urlencoded"
  }.freeze

  LINE_TOKEN_URL = "https://api.line.me/oauth2/v2.1/token"
  LINE_INFORMATION_URL = "https://api.line.me/v2/profile"

  def self.singleton
    @singleton ||= new
  end

  def retrieve_access_token(redirect_uri:, code:)
    response = HTTParty.post(
      LINE_TOKEN_URL,
      headers: LINE_BASE_HEADERS,
      body: URI.encode_www_form({
        grant_type: "authorization_code",
        code: code,
        redirect_uri: redirect_uri,
        client_id: Ibrain::Auth::Config.line_client_id,
        client_secret: Ibrain::Auth::Config.line_client_secret
      })
    )

    response.try(:fetch, "access_token", nil)
  end

  def retrieve_uid(redirect_uri:, code:)
    token = retrieve_access_token(
      redirect_uri: redirect_uri,
      code: code
    )

    response = HTTParty.get(
      LINE_INFORMATION_URL,
      headers: LINE_BASE_HEADERS.merge({
        'Authorization' => "Bearer #{token}"
      })
    )

    response.try(:fetch, 'userId', nil)
  end

  def retrieve_uid_by_access_token(access_token:)
    response = HTTParty.get(
      LINE_INFORMATION_URL,
      headers: LINE_BASE_HEADERS.merge({
        'Authorization' => "Bearer #{access_token}"
      })
    )

    response.try(:fetch, 'userId', nil)
  end
end
