require 'faraday'
require 'json'
require 'open3'

class YoutubeTranscriptService
  # YouTubeの動画IDをURLから抽出するメソッド
  def self.extract_youtube_id(url)
    uri = URI.parse(url)
    query = URI.decode_www_form(uri.query || '').to_h
    query['v'] || uri.path.split('/').last
  end

  # Pythonスクリプトで文字起こしを取得するメソッド
  def self.fetch_transcript(youtube_id)
    transcript, = Open3.capture2('python3', 'lib/get_transcript.py', youtube_id)
    transcript.strip
  end

  # Gemini APIで要約を生成するメソッド
  def self.generate_summary(text)
    api_url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent'
    api_key = Rails.application.credentials.dig(:google, :gemini_api_key)

    conn = Faraday.new(url: "#{api_url}?key=#{api_key}") do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
    end

    request_text = "プロのライターが要約するように日本語で要約して。ただし、マークダウン記法は使わないで。:\n\n#{text}"

    response = conn.post do |req|
      req.body = {
        contents: [
          {
            parts: [
              { text: request_text },
            ],
          },
        ],
      }.to_json
    end

    JSON.parse(response.body)['candidates'].first['content']['parts'].first['text']
  end
end
