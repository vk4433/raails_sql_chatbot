require 'mysql2'

class MysqlConnector
  def initialize(sql_credential)
    @sql_credential = sql_credential
  end

  def check_credential
    begin
      client = Mysql2::Client.new(
        host: @sql_credential.host,
        username: @sql_credential.username,
        password: @sql_credential.password,
        database: @sql_credential.database.strip,
        port: @sql_credential.port,
        socket: @sql_credential.socket
      )
      client.close
      true
    rescue Mysql2::Error => e
      Rails.logger.error("MySQL connection failed: #{e.message}")
      false
    end
  end

  def fetch_tables_and_columns
    begin
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

      client.close
      tables_info
    rescue Mysql2::Error => e
      Rails.logger.error("Error fetching tables/columns: #{e.message}")
      {}
    end
  end
end
