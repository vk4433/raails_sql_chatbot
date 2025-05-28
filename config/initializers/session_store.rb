# Be sure to restart your server when you modify this file.

# Use the database as session store for the test and development environments
if Rails.env.development? || Rails.env.test?
  Rails.application.config.session_store :active_record_store, key: '_sql_chatbot_session'
else
  # Use cookie store for production (Render free tier) to avoid database session table issues
  Rails.application.config.session_store :cookie_store, key: '_sql_chatbot_session'
end

# Configure session options
Rails.application.config.session_options = {
  # Set session timeout to 30 minutes of inactivity
  expire_after: 30.minutes,
  # Secure cookies in production
  secure: Rails.env.production?,
  # HttpOnly to prevent JavaScript access
  httponly: true
}
