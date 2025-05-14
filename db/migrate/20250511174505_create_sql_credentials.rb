class CreateSqlCredentials < ActiveRecord::Migration[7.2]
  def change
    create_table :sql_credentials do |t|
      t.string :host
      t.string :username
      t.string :password
      t.string :database
      t.integer :port
      t.string :socket
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end

end
