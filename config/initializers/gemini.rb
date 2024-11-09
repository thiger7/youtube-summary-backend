require "faraday"
require "json"

# サービスアカウントのパスを環境変数として設定
ENV['GOOGLE_APPLICATION_CREDENTIALS'] = Rails.application.credentials.dig(:google, :gemini_application_credentials)
