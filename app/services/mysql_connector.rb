# app/services/mysql_connector.rb
require 'mysql2'

class MysqlConnector
  def initialize(sql_credential)
    @sql_credential = sql_credential
  end

  def fetch_tables_and_columns
    client = Mysql2::Client.new(
      host: @sql_credential.host,
      username: @sql_credential.username,
      password: @sql_credential.password,
      database: @sql_credential.database.strip,
      port: @sql_credential.port,
      socket: @sql_credential.socket
    )

    tables_info = {}

    tables = client.query("SHOW TABLES")
    tables.each do |table|
      table_name = table.values.first
      columns_name = []

      columns = client.query("DESCRIBE #{table_name}")
      columns.each do |column|
        columns_name << column["Field"]
      end

      tables_info[table_name] = columns_name
    end

    tables_info
  end
end
