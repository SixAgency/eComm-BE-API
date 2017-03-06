# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.

# encrypted_data: credit card nonce, used by square
Rails.application.config.filter_parameters += [:password, :encrypted_data]