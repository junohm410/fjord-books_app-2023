class Reports::CommentsController < ApplicationController
  def create
    @report = Report.find(params[:report_id])
    @comment = @report.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to report_path(@report)
  end

  def destroy
    @report = Report.find(params[:report_id])
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to report_path(@report), status: :see_other
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
