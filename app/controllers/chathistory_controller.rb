class ChathistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_query, only: :create
  layout false

  def index
    @chat_history = Chathistory.where(user: current_user).order(created_at: :desc)

    @sql_credential = current_user.sql_credential
    
    if @sql_credential.present?
      mysql_connector = MysqlConnector.new(@sql_credential)
    
      if mysql_connector.check_credential
        tables_data = mysql_connector.fetch_tables_and_columns
    
        # Just assign all tables without pagination
        @tables_info = tables_data.map do |table_name, columns|
          {
            table_name: table_name,
            columns: columns || []
          }
        end
      else
        flash[:alert] = "Invalid database credentials. Please update them to proceed."
        redirect_to edit_sql_credential_path(@sql_credential) and return
      end
    else
      flash[:alert] = "No database credentials found."
      redirect_to new_sql_credential_path and return
    end
    

    # Load query result from flash if available (pagination for result rows)
    if flash[:result]
      @query_result = Kaminari.paginate_array(flash[:result]).page(params[:page]).per(20)
      @question = flash[:question]
      @executed_query = flash[:executed_query]
    end
  end

  def create
    schema = fetch_schema
    user_query = params[:query]

    # Generate SQL query
    sql_query = QueryGeneration.generate_query(schema, user_query)

    # Execute SQL query
    result = execute_sql_query(sql_query)

    # Save chat history
    Chathistory.create!(
      user: current_user,
      question: user_query,
      generated_sql: sql_query
    )

    # Store in flash to show in index view after redirect
    flash[:question] = user_query
    flash[:executed_query] = sql_query
    flash[:result] = result

    redirect_to chathistory_index_path
  end

  private

  def validate_query
    return if params[:query].present?

    flash[:error] = "Query cannot be empty"
    redirect_to chathistory_index_path
  end

  def fetch_schema
    connector = MysqlConnector.new(current_user.sql_credential)
    schema = connector.fetch_tables_and_columns
    schema.map { |table, columns| "#{table}(#{columns.join(', ')})" }.join(", ")
  end

  def execute_sql_query(sql_query)
    sql_query = sql_query.strip

    client = Mysql2::Client.new(
      host: current_user.sql_credential.host,
      username: current_user.sql_credential.username,
      password: current_user.sql_credential.password,
      database: current_user.sql_credential.database.strip,
      port: current_user.sql_credential.port,
      socket: current_user.sql_credential.socket
    )

    client.query(sql_query, symbolize_keys: true).to_a
  rescue Mysql2::Error => e
    Rails.logger.error("SQL Query Error: #{e.message}")
    [{ error: "Failed to execute query: #{e.message}" }]
  ensure
    client&.close
  end
end
