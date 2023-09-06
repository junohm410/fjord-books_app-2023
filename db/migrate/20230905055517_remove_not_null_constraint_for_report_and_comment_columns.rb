class RemoveNotNullConstraintForReportAndCommentColumns < ActiveRecord::Migration[7.0]
  def change
    change_column_null :reports, :user_id, true
    change_column_null :comments, :user_id, true
  end
end
