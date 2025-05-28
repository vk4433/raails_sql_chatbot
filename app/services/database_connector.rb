require 'logger'

class DatabaseConnector
  def initialize(sql_credential)
    @sql_credential = sql_credential
    @logger = Logger.new(STDOUT)
    @adapter = Rails.env.production? ? :postgresql : :mysql
  end

  def check_credential
    if @adapter == :postgresql
      check_postgres_credential
    else
      check_mysql_credential
    end
  end

  def fetch_tables_and_columns
    if @adapter == :postgresql
      fetch_postgres_tables_and_columns
    else
      fetch_mysql_tables_and_columns
    end
  end

  private

  def check_postgres_credential
    begin
      require 'pg'
      conn = PG.connect(
        host: @sql_credential.host,
        user: @sql_credential.username,
        password: @sql_credential.password,
        dbname: @sql_credential.database.strip,
        port: @sql_credential.port
      )
      conn.close
      true
    rescue PG::Error => e
      @logger.error("PostgreSQL connection failed: #{e.message}")
      false
    end
  end

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

  def fetch_postgres_tables_and_columns
    begin
      require 'pg'
      conn = PG.connect(
        host: @sql_credential.host,
        user: @sql_credential.username,
        password: @sql_credential.password,
        dbname: @sql_credential.database.strip,
        port: @sql_credential.port
      )

      tables_info = {}

      # Get all tables in the current schema
      tables_query = "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public'"
      tables = conn.exec(tables_query)
      
      tables.each do |table|
        table_name = table['tablename']
        columns_name = []

        # Get columns for each table
        columns_query = "SELECT column_name FROM information_schema.columns WHERE table_name = '#{table_name}' AND table_schema = 'public'"
        columns = conn.exec(columns_query)
        
        columns.each do |column|
          columns_name << column['column_name']
        end

        tables_info[table_name] = columns_name
      end

      conn.close
      tables_info
    rescue PG::Error => e
      @logger.error("Error fetching PostgreSQL tables/columns: #{e.message}")
      {}
    rescue LoadError => e
      @logger.error("PostgreSQL library not available: #{e.message}")
      {}
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
