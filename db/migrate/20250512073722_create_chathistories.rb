class CreateChathistories < ActiveRecord::Migration[7.2]
  def change
    create_table :chathistories do |t|
      t.references :user, null: false, foreign_key: true
      t.text :question
      t.text :generated_sql

      t.timestamps
    end
  end
end
