class ApplicationController < ActionController::Base
  # After sign in, redirect here
  def after_sign_in_path_for(resource)
    root_path
  end

  # After sign out, redirect here
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
