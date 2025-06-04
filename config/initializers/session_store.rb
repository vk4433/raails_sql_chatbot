# Use cookies for session storage by default
Rails.application.config.session_store :cookie_store, key: '_raails_sql_chatbot_session'

# To use Redis for session storage, uncomment these lines and make sure redis-store gem is installed
# Rails.application.config.session_store :redis_store,
#   servers: [ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')],
#   expire_after: 90.minutes,
#   key: '_raails_sql_chatbot_session'
