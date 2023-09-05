# frozen_string_literal: true

class ReportMentionRelationship < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report'
  belongs_to :mentioned, class_name: 'Report'

  validates :mentioned_report_id, uniqueness: { scope: :mentioning_report_id }
end
