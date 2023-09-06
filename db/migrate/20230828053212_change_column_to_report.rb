class ChangeColumnToReport < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :reports, :users
  end
end
