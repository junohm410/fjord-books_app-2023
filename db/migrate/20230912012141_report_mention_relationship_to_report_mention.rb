class ReportMentionRelationshipToReportMention < ActiveRecord::Migration[7.0]
  def change
    rename_table :report_mention_relationships, :report_mentions
  end
end
