# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_URI_REGEXP = %r{http://localhost:3000/reports/(\d+)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentions, class_name: 'ReportMention', inverse_of: :mentioning_report, foreign_key: 'mentioning_report_id', dependent: :destroy
  has_many :passive_mentions, class_name: 'ReportMention', inverse_of: :mentioned_report, foreign_key: 'mentioned_report_id', dependent: :destroy

  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_report_and_mentioning_relationship
    transaction do
      raise ActiveRecord::Rollback unless save

      create_new_mentioning_relationship
    end
  end

  def update_report_and_mentioning_relationship(report_params)
    transaction do
      raise ActiveRecord::Rollback unless update(report_params)

      active_mentions.destroy_all
      create_new_mentioning_relationship
    end
  end

  def search_mentioned_report_ids
    content.scan(REPORT_URI_REGEXP).flatten.uniq.filter_map do |report_id|
      report_id.to_i if Report.exists?(report_id)
    end
  end

  def create_new_mentioning_relationship
    mentioned_report_ids = search_mentioned_report_ids
    mentioned_report_ids.each do |mentioned_report_id|
      active_mentions.create!(mentioned_report_id:)
    end
  end
end
