# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_relationships, class_name: "ReportMentionRelationship", foreign_key: "mentioning_report_id", dependent: :destroy
  has_many :mentioned_relationships, class_name: "ReportMentionRelationship", foreign_key: "mentioned_report_id", dependent: :destroy

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
      save!
      mentioned_report_ids = search_mentioned_report_ids
      mentioned_report_ids.each do |mentioned_report_id|
        create_new_mentioning_relationship(mentioned_report_id)
      end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update_report_and_mentioning_relationship(old_mentioned_report_ids, report_params)
    transaction do
      update!(report_params)
      submitted_mentioned_report_ids = search_mentioned_report_ids
      update_mentioning_relationship(old_mentioned_report_ids, submitted_mentioned_report_ids)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def search_mentioned_report_ids
    content.scan(/http:\/\/localhost:3000\/reports\/(\d+)/).flatten.uniq.map(&:to_i)
  end

  def create_new_mentioning_relationship(mentioned_report_id)
    ReportMentionRelationship.create!(mentioning_report_id: id, mentioned_report_id:)
  end

  def update_mentioning_relationship(old_mentioned_report_ids, submitted_mentioned_report_ids)
    remaining_mentioned_report_ids = old_mentioned_report_ids & submitted_mentioned_report_ids
    no_longer_mentioned_report_ids = old_mentioned_report_ids - remaining_mentioned_report_ids
    new_mentioned_report_ids = submitted_mentioned_report_ids - remaining_mentioned_report_ids

    no_longer_mentioned_report_ids.each do |mentioned_report_id|
      find_mentioning_relationship(mentioned_report_id).destroy
    end

    new_mentioned_report_ids.each do |mentioned_report_id|
      create_new_mentioning_relationship(mentioned_report_id)
    end
  end

  def find_mentioning_relationship(mentioned_report_id)
    ReportMentionRelationship.find_by(mentioning_report_id: id, mentioned_report_id:)
  end
end
