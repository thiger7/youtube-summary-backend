# app/controllers/videos_controller.rb
class VideosController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    youtube_url = params[:youtube_url]
    YoutubeSummaryJob.perform_later(youtube_url)

    render json: { message: "Job started for YouTube URL: #{youtube_url}" }, status: :accepted
  end

  def show
    youtube_url = params[:youtube_url]
    youtube_id = YoutubeTranscriptService.extract_youtube_id(youtube_url)

    summary_record = Summary.where(youtube_id: youtube_id).order(created_at: :desc).first

    if summary_record
      render json: { summary: summary_record.summary, transcript: summary_record.transcript }
    else
      render json: { message: 'Processing, please wait...' }, status: :accepted
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Record not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
