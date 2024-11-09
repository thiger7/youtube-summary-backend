require 'faraday'
require 'json'

class YoutubeTranscriptService
  # YouTubeの動画IDをURLから抽出するメソッド
  def self.extract_youtube_id(url)
    uri = URI.parse(url)
    query = URI.decode_www_form(uri.query || "").to_h
    query["v"] || uri.path.split("/").last
  end

  # Pythonスクリプトで文字起こしを取得するメソッド
  def self.fetch_transcript(youtube_id)
    transcript = `python3 lib/get_transcript.py #{youtube_id}`
    transcript.strip
  end

  # Gemini APIで要約を生成するメソッド
  def self.generate_summary(text)
    api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    api_key = Rails.application.credentials.dig(:google, :gemini_api_key) # APIキーをcredentialsに設定しておく

    conn = Faraday.new(url: "#{api_url}?key=#{api_key}") do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
    end

    response = conn.post do |req|
      req.body = {
        contents: [
          {
            parts: [
              { text: text }
            ]
          }
        ]
      }.to_json
    end

    JSON.parse(response.body)["candidates"].first["content"]["parts"].first["text"]
  end

  # URLを入力して文字起こしと要約を取得するメインメソッド
  def self.process(url)
    youtube_id = extract_youtube_id(url)
    transcript = fetch_transcript(youtube_id)
    summary = generate_summary(transcript)
    summary
  end
end
