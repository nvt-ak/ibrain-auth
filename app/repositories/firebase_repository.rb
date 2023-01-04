# frozen_string_literal: true

require 'open-uri'

class FirebaseRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @private_key_json = load_private_file
    @firebase_owner_email = Ibrain::Auth::Config.firebase_owner_email
    @params = params
  end

  def generate_custom_token!
    now = Time.now.to_i

    payload = {
      iss: firebase_owner_email,
      sub: firebase_owner_email,
      aud: Ibrain::Auth::Config.firebase_auth_url,
      iat: now,
      exp: now + 3600,
      uid: params[:uid],
      claims: {}
    }

    JWT.encode payload, private_key, "RS256"
  end

  private

  attr_reader :private_key_json, :firebase_owner_email, :params

  def json_firebase
    JSON.parse(private_key_json, symbolize_names: true)
  end

  def private_key
    OpenSSL::PKey::RSA.new json_firebase[:private_key]
  end

  def load_private_file
    is_remote = Ibrain::Auth::Config.firebase_private_key_path.include?("http")

    if is_remote
      uri = URI.parse(Ibrain::Auth::Config.firebase_private_key_path)
      content = uri.open { |f| f.read }

      return content
    end

    File.open(Ibrain::Auth::Config.firebase_private_key_path).read
  end
end
