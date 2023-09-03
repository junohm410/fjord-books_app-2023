class ReportMentionRelationship < ApplicationRecord
  belongs_to :mentioning_report, class_name: "Report" 
  belongs_to :mentioned_report, class_name: "Report"
end
