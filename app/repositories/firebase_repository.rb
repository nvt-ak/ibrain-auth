# frozen_string_literal: true

class FirebaseRepository < Ibrain::BaseRepository
  def initialize(record, _params)
    super(nil, record)

    @private_key_json = File.open(Ibrain::Auth::Config.firebase_private_key_path).read
    @firebase_owner_email = Ibrain::Auth::Config.firebase_owner_email
  end

  def generate_custom_token!
    now = Time.now.to_i

    payload = {
      iss: firebase_owner_email,
      sub: firebase_owner_email,
      aud: Ibrain::Auth::Config.firebase_aud_url,
      iat: now,
      exp: now + 3600,
      uid: params[:uid],
      claims: {}
    }

    JWT.encode payload, private_key, "RS256"
  end

  private

  attr_reader :private_key_json, :firebase_owner_email

  def method_name
  end

  def json_firebase
    JSON.parse(private_key_json, symbolize_names: true)
  end

  def private_key
    OpenSSL::PKey::RSA.new json_firebase[:private_key]
  end
end
