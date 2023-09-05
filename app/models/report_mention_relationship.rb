class ReportMentionRelationship < ApplicationRecord
  belongs_to :mentioning_report, class_name: "Report" 
  belongs_to :mentioned_report, class_name: "Report"

  validates :mentioned_report_id, uniqueness: { scope: :mentioning_report_id }
  validates :mentioned_report_id, numericality: { less_than: Report.last.id }
end
