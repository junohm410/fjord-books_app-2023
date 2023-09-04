# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  def create
    @commentable = Report.find(params[:report_id])
    super
    redirect_to report_path(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def destroy
    @commentable = Report.find(params[:report_id])
    super
    redirect_to report_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end
end
