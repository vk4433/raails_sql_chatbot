class SqlCredentialsController < ApplicationController
  before_action :authenticate_user!  # Ensure user is logged in

  def index
    @sql_credentials = current_user.sql_credential
  end

  def new
    # Check if the user already has a credential
    if current_user.sql_credential.present?
      redirect_to sql_credential_path(current_user.sql_credential), alert: "You already have an SQL credential."
    else
      @sql_credential = SqlCredential.new
    end
  end

  def create
    # Check if the user already has a credential
    if current_user.sql_credential.present?
      redirect_to sql_credential_path(current_user.sql_credential), alert: "You already have an SQL credential."
    else
      # Use current_user.sql_credential (has_one relationship)
      @sql_credential = current_user.build_sql_credential(sql_credential_params)

      if @sql_credential.save
        redirect_to sql_credential_path(@sql_credential), notice: "SQL Credential saved successfully."
      else
        render :new
      end
    end
  end

  def show
    @sql_credential = current_user.sql_credential
    if @sql_credential.present?
      mysql_connector = MysqlConnector.new(@sql_credential)
      tables_data = mysql_connector.fetch_tables_and_columns
      # Paginate the array of table names (keys) using Kaminari
      @tables_info = Kaminari.paginate_array(tables_data.keys).page(params[:page]).per(3)

      # Prepare an array of columns for the current page"s tables
      @current_page_tables = @tables_info.map { |table_name|
        {
          table_name: table_name,
          columns: tables_data[table_name] || []  # Ensure columns is never nil
        }
      }
    else
      @tables_info = []
    end
  end

  # Edit action to load the current SQL credential
  def edit
    @sql_credential = current_user.sql_credential
  end

  # Update action to save the edited SQL credential
  def update
    @sql_credential = current_user.sql_credential

    if @sql_credential.update(sql_credential_params)
      redirect_to sql_credential_path(@sql_credential), notice: "SQL Credential updated successfully."
    else
      render :edit
    end
  end

  private

  def sql_credential_params
    params.require(:sql_credential).permit(:host, :username, :password, :database, :port, :socket)
  end
end
