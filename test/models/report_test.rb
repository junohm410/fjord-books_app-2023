# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'Report#editable? should return true if the report is editable by the report poster' do
    report = reports(:one)
    assert report.editable?(users(:alice))
  end

  test 'Report#editable? should return false if the report is not editable by a person who is not its poster' do
    report = reports(:one)
    assert_not report.editable?(users(:bob))
  end

  test 'Report#created_on should return Date object' do
    report = reports(:one)
    assert_instance_of Date, report.created_on
  end

  test 'after new mention to some reports are saved by another report, those mentioned reports can refer the mentioning report' do
    mentioning_report = users(:carol).reports.new(title: 'helpful reports', content: 'http://localhost:3000/reports/1\nhttp://localhost:3000/reports/2')
    mentioning_report.save
    assert_includes reports(:one).mentioned_reports, mentioning_report
    assert_includes reports(:two_mentioning_report_one).mentioned_reports, mentioning_report
  end

  test 'even if a report without any mention is saved, the total number of records of report mention should not be changed' do
    report_without_any_mention = users(:carol).reports.new(title: 'Day1', content: 'content without any mention')
    assert_no_difference 'ReportMention.count' do
      report_without_any_mention.save
    end
  end

  test 'if existing mention is deleted by update for a mentioning report, associated records of report mention should be deleted too' do
    mentioning_report = reports(:two_mentioning_report_one)
    mentioning_report.content = 'deleted a mention part for reports/1'
    mentioning_report.save
    assert_not_includes reports(:one).mentioned_reports, mentioning_report
  end

  test 'even if a report mentions the same report in itself, an associated record of report mention should not be duplicated' do
    mentioning_report = reports(:two_mentioning_report_one)
    mentioning_report.content = 'http://localhost:3000/reports/1\nhttp://localhost:3000/reports/1'
    assert_no_difference 'ReportMention.count' do
      mentioning_report.save
    end
  end

  test 'even if a report mentions itself, the record of the mention should not be recorded' do
    mentioning_report = reports(:one)
    mentioning_report.content = 'http://localhost:3000/reports/1'
    assert_no_difference 'ReportMention.count' do
      mentioning_report.save
    end
  end
end
