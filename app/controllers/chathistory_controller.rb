class ChathistoryController < ApplicationController
  def index
    @chat_history = Chathistory.where(user: current_user).order(created_at: :desc)
  end

  def create
    schema = fetch_schema
    user_query = params[:query] || "default user query"

    # Generate SQL query
    sql_query = QueryGeneration.generate_query(schema, user_query)

    # Execute SQL query
    result = execute_sql_query(sql_query)

    # Save only user question and generated SQL (NOT result)
    Chathistory.create!(
      user: current_user,
      question: user_query,
      generated_sql: sql_query
    )

    flash[:executed_query] = sql_query
    flash[:result] = result
    redirect_to chathistory_index_path
  end

  private

  def fetch_schema
    connector = MysqlConnector.new(current_user.sql_credential)
    schema = connector.fetch_tables_and_columns
    schema.map { |table, columns| "#{table}(#{columns.join(', ')})" }.join(", ")
  end

  def execute_sql_query(sql_query)
    client = Mysql2::Client.new(
      host: current_user.sql_credential.host,
      username: current_user.sql_credential.username,
      password: current_user.sql_credential.password,
      database: current_user.sql_credential.database.strip,
      port: current_user.sql_credential.port,
      socket: current_user.sql_credential.socket
    )
    client.query(sql_query).to_a
  rescue => e
    [ { "error" => e.message } ]
  end
end
