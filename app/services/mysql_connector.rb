# This file is kept for backward compatibility
# The actual implementation has been moved to database_connector.rb

require_relative 'database_connector'

class MysqlConnector < DatabaseConnector
  # All functionality is now in the parent class
end
