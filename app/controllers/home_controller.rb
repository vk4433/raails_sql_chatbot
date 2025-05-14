class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @sql_credential = current_user.sql_credential

    if @sql_credential.blank?
      # Render the home page with the prompt for creating credentials instead of redirecting.
      flash[:alert] = " Please create your SQL credential to connect to the server."
      render "index"
    end
  end
end
