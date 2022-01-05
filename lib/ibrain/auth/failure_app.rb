# frozen_string_literal: true

class Ibrain::Auth::FailureApp < Devise::FailureApp
  include ActionController::Helpers

  def respond
    json_error_response
  end

  def json_error_response
    self.status = 401
    self.content_type = "application/json"
    self.response_body = {
      errors: [{
              message: i18n_message,
              extensions: {
                code: 401,
                exception: {
                  stacktrace: []
                }
              }
            }],
            message: i18n_message,
            data: nil
          }.to_json
  end
end
