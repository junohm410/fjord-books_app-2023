# frozen_string_literal: true

module ReportsHelper
  def report_user_name(user)
    [user.name, user.email].find(&:present?)
  end
end
