# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
