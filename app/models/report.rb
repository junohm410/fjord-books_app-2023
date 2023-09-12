# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_URI_REGEXP = %r{http://localhost:3000/reports/(\d+)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mention_relationships, class_name: 'ReportMention', inverse_of: :mentioning_report, foreign_key: 'mentioning_report_id', dependent: :destroy
  has_many :mentioned_relationships, class_name: 'ReportMention', inverse_of: :mentioned_report, foreign_key: 'mentioned_report_id', dependent: :destroy

  has_many :mentioning_reports, through: :mention_relationships, source: :mentioned_report
  has_many :mentioned_reports, through: :mentioned_relationships, source: :mentioning_report

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

      mentioned_report_ids = search_mentioned_report_ids
      mentioned_report_ids.each do |mentioned_report_id|
        create_new_mentioning_relationship(mentioned_report_id)
      end
    end
  end

  def update_report_and_mentioning_relationship(report_params)
    transaction do
      raise ActiveRecord::Rollback unless update(report_params)

      mentioned_report_ids = search_mentioned_report_ids
      update_mentioning_relationship(mentioned_report_ids)
    end
  end

  def search_mentioned_report_ids
    content.scan(REPORT_URI_REGEXP).flatten.uniq.map(&:to_i)
  end

  def create_new_mentioning_relationship(mentioned_report_id)
    ReportMention.create!(mentioning_report_id: id, mentioned_report_id:)
  end

  def update_mentioning_relationship(mentioned_report_ids)
    mention_relationships.delete_all
    mentioned_report_ids.each do |mentioned_report_id|
      create_new_mentioning_relationship(mentioned_report_id)
    end
  end
end
