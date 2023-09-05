# frozen_string_literal: true

class Report < ApplicationRecord
  include ActionView::Helpers::TranslationHelper
  REPORT_URI = %r{http://localhost:3000/reports/(\d+)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_relationships, class_name: 'ReportMentionRelationship', inverse_of: :mentioning_report, foreign_key: 'mentioning_report_id', dependent: :destroy
  has_many :mentioned_relationships, class_name: 'ReportMentionRelationship', inverse_of: :mentioned_report, foreign_key: 'mentioned_report_id', dependent: :destroy

  has_many :mentioning_reports, through: :mentioning_relationships, source: :mentioned_report
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
      save
      raise ActiveRecord::Rollback unless persisted?

      mentioned_report_ids = search_mentioned_report_ids
      mentioned_report_ids.each do |mentioned_report_id|
        create_new_mentioning_relationship(mentioned_report_id, self)
      end
    end
  end

  def update_report_and_mentioning_relationship(report_params)
    old_mentioned_report_ids = mentioning_reports.ids

    transaction do
      update(report_params)
      raise ActiveRecord::Rollback unless saved_changes?

      submitted_mentioned_report_ids = search_mentioned_report_ids
      update_mentioning_relationship(old_mentioned_report_ids, submitted_mentioned_report_ids, self)
    end
  end

  def search_mentioned_report_ids
    content.scan(REPORT_URI).flatten.uniq.map(&:to_i)
  end

  def create_new_mentioning_relationship(mentioned_report_id, report)
    new_mention_relationship = ReportMentionRelationship.new(mentioning_report_id: id, mentioned_report_id:)
    new_mention_relationship.save
    return if new_mention_relationship.persisted?

    report.errors.add(:base, t('errors.mention_relationships.has_errors'))
    raise ActiveRecord::Rollback
  end

  def update_mentioning_relationship(old_mentioned_report_ids, submitted_mentioned_report_ids, report)
    remaining_mentioned_report_ids = old_mentioned_report_ids & submitted_mentioned_report_ids
    no_longer_mentioned_report_ids = old_mentioned_report_ids - remaining_mentioned_report_ids
    new_mentioned_report_ids = submitted_mentioned_report_ids - remaining_mentioned_report_ids

    no_longer_mentioned_report_ids.each do |mentioned_report_id|
      find_mentioning_relationship(mentioned_report_id).destroy!
    end

    new_mentioned_report_ids.each do |mentioned_report_id|
      create_new_mentioning_relationship(mentioned_report_id, report)
    end
  end

  def find_mentioning_relationship(mentioned_report_id)
    ReportMentionRelationship.find_by(mentioning_report_id: id, mentioned_report_id:)
  end
end
