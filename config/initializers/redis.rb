# Initialize Redis connection
$redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/1")

# Test Redis connection on application startup
begin
  $redis.ping
  Rails.logger.info "Connected to Redis successfully"
rescue Redis::CannotConnectError => e
  Rails.logger.error "Failed to connect to Redis: #{e.message}"
end
