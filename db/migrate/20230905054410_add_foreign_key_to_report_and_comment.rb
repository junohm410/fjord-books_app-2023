class AddForeignKeyToReportAndComment < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :reports, :users
    add_foreign_key :comments, :users
  end
end
