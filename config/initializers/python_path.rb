# Set Python path to include our Python directory
python_dir = Rails.root.join('python').to_s
ENV['PYTHONPATH'] = [ENV['PYTHONPATH'], python_dir].compact.join(':')

# Log Python configuration for debugging
Rails.logger.info "Python path set to: #{ENV['PYTHONPATH']}"
