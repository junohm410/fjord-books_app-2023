class CreateReportMentionRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mention_relationships do |t|
      t.references :mentioning_report, null: false, foreign_key: { to_table: :reports }
      t.references :mentioned_report, null: false, foreign_key: { to_table: :reports }

      t.timestamps
    end
  end
end
