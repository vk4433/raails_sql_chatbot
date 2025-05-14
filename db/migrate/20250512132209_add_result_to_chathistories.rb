class AddResultToChathistories < ActiveRecord::Migration[7.2]
  def change
    add_column :chathistories, :result, :text
  end
end
