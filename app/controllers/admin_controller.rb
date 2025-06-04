class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def confirm_users
    @unconfirmed_users = User.where(confirmed_at: nil)
  end

  def confirm_user
    @user = User.find(params[:id])
    @user.confirm
    redirect_to admin_confirm_users_path, notice: "User #{@user.email} has been confirmed."
  end

  private

  def check_admin
    # Implement your admin check logic here
    # For example:
    # redirect_to root_path, alert: "Not authorized" unless current_user.admin?
    # 
    # For now, we'll just allow any authenticated user for testing
  end
end
