# frozen_string_literal: true

class Books::CommentsController < CommentsController
  def create
    @commentable = Book.find(params[:book_id])
    super
    redirect_to book_path(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def destroy
    @commentable = Book.find(params[:book_id])
    super
    redirect_to book_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end
end
