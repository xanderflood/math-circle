require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MathCircle
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = 'Eastern Time (US & Canada)'
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.action_mailer.default_url_options = { :host => 'localhost' }
  end
end
