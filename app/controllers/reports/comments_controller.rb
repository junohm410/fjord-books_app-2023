class Reports::CommentsController < ApplicationController
  def create
    @report = Report.find(params[:report_id])
    @comment = @report.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to report_path(@report), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def destroy
    @report = Report.find(params[:report_id])
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to report_path(@report), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
