class ChangeDataColumnTypeInSessions < ActiveRecord::Migration[7.2]
  def change
    change_column :sessions, :data, :text
  end
end
