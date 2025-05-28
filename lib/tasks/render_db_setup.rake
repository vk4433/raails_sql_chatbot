namespace :render do
  desc "Setup database for Render deployment"
  task setup_database: :environment do
    puts "Starting Render database setup..."
    
    # Check if we're connected to the database
    begin
      ActiveRecord::Base.connection
      puts "Database connection established."
    rescue => e
      puts "Error connecting to database: #{e.message}"
      puts "Will attempt to create database..."
      Rake::Task["db:create"].invoke rescue puts "Database creation failed or already exists."
    end
    
    # Check if schema exists
    tables = ActiveRecord::Base.connection.tables
    puts "Current tables in database: #{tables.join(', ')}"
    
    if tables.empty? || !tables.include?('users')
      puts "Schema not found or incomplete. Loading schema..."
      begin
        Rake::Task["db:schema:load"].invoke
        puts "Schema loaded successfully."
      rescue => e
        puts "Error loading schema: #{e.message}"
        puts "Will attempt to run migrations instead..."
      end
    end
    
    # Run migrations regardless
    puts "Running migrations..."
    begin
      Rake::Task["db:migrate"].invoke
      puts "Migrations completed successfully."
    rescue => e
      puts "Error running migrations: #{e.message}"
    end
    
    # Verify tables after setup
    tables = ActiveRecord::Base.connection.tables
    puts "Tables after setup: #{tables.join(', ')}"
    
    # Check for specific required tables
    required_tables = ['users', 'sql_credentials', 'chathistories']
    missing_tables = required_tables - tables
    
    if missing_tables.empty?
      puts "All required tables exist. Database setup complete!"
    else
      puts "WARNING: Some required tables are still missing: #{missing_tables.join(', ')}"
      puts "You may need to check your migrations or schema."
    end
  end
end
