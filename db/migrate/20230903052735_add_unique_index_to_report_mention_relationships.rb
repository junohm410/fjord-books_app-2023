class AddUniqueIndexToReportMentionRelationships < ActiveRecord::Migration[7.0]
  def change
    add_index :report_mention_relationships, [:mentioning_report_id, :mentioned_report_id], unique: true, name: 'mentioning_and_mentioned_unique_index'
  end
end
