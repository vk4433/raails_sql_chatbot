namespace :python do
  desc "Verify Python setup and dependencies"
  task :verify => :environment do
    puts "Checking Python setup..."
    
    # Check Python version
    python_version = `python --version 2>&1`.strip
    puts "Python version: #{python_version}"
    
    # Check if required packages are installed
    puts "Checking Python packages..."
    requirements = File.read(Rails.root.join('requirements.txt')).split("\n")
    requirements.each do |req|
      next if req.strip.empty? || req.start_with?('#')
      package = req.split('==').first.split('>=').first.strip
      puts "Checking package: #{package}"
      system("pip show #{package}")
    end
    
    puts "Python path: #{ENV['PYTHONPATH']}"
    puts "Python verification complete."
  end
  
  desc "Install Python dependencies"
  task :install => :environment do
    puts "Installing Python dependencies..."
    system("pip install -r #{Rails.root.join('requirements.txt')}")
    puts "Python dependencies installed."
  end
end
