# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)

    visit root_url
    fill_in 'Eメール',	with: 'alice@example.com'
    fill_in 'パスワード',	with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'visiting a report' do
    visit report_url(@report)
    assert_selector 'h1', text: '日報の詳細'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in '内容', with: "Day1"
    fill_in 'タイトル', with: "I do my best"
    click_on '登録する'

    assert_text '日報が作成されました。'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in '内容', with: "Modified title"
    fill_in 'タイトル', with: "Modified content"
    click_on '更新する'

    assert_text '日報が更新されました。'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
  end

  test 'should not see link to edit Report by others' do
    report_by_bob = reports(:two_mentioning_report_one)
    visit report_url(report_by_bob)

    assert_no_link 'この日報を編集'
  end

  test 'should not see button to delete Report by others' do
    report_by_bob = reports(:two_mentioning_report_one)
    visit report_url(report_by_bob)

    assert_no_button 'この日報を削除'
  end
end
