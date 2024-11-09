class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    @new_comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      respond_to do |format|
        format.html { redirect_to comments_path } # 通常のリダイレクト
        format.turbo_stream # TurboStream対応
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
