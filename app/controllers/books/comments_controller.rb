class Books::CommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = @book.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to report_path(@book), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to report_path(@book), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
