require 'logger'

class DatabaseConnector
  def initialize(sql_credential)
    @sql_credential = sql_credential
    @logger = Logger.new(STDOUT)
  end

  def check_credential
    check_mysql_credential
  end

  def fetch_tables_and_columns
    fetch_mysql_tables_and_columns
  end

  private

  def check_mysql_credential
    begin
      require 'mysql2'
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
      @logger.error("MySQL connection failed: #{e.message}")
      false
    rescue LoadError => e
      @logger.error("MySQL library not available: #{e.message}")
      false
    end
  end

  def fetch_mysql_tables_and_columns
    begin
      require 'mysql2'
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
      @logger.error("Error fetching MySQL tables/columns: #{e.message}")
      {}
    rescue LoadError => e
      @logger.error("MySQL library not available: #{e.message}")
      {}
    end
  end
end
