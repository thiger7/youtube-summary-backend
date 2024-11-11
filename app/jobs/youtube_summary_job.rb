class YoutubeSummaryJob < ApplicationJob
  queue_as :default

  def perform(url)
    # YouTube IDの抽出と文字起こし、要約の生成
    youtube_id = YoutubeTranscriptService.extract_youtube_id(url)
    transcript = YoutubeTranscriptService.fetch_transcript(youtube_id)
    summary_text = YoutubeTranscriptService.generate_summary(transcript)

    # データベースに保存
    Summary.create(
      youtube_id: youtube_id,
      transcript: transcript,
      summary: summary_text,
    )
  end
end
