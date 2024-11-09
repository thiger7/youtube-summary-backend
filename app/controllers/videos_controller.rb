# app/controllers/videos_controller.rb
class VideosController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    youtube_id = params[:youtube_id]
    transcript = YoutubeTranscriptService.fetch_transcript(youtube_id)
    render json: { transcript: transcript }
  end
end
