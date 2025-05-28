#!/usr/bin/env bash
# exit on error
set -o errexit

# Check Ruby and Python versions
echo "Ruby version:"
ruby --version
echo "Python version:"
python --version

# Install Ruby dependencies
echo "Installing Ruby dependencies..."
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

# Install Python dependencies
if [ -f "requirements.txt" ]; then
  echo "Installing Python dependencies..."
  pip install --upgrade pip
  pip install -r requirements.txt
fi

# Set Python path for the application
echo "export PYTHONPATH=$PYTHONPATH:$(pwd)/python" >> ~/.bashrc
echo "PYTHONPATH set to include $(pwd)/python"
