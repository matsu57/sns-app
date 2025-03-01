require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SnsApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # OpenSSLの対応
    if Rails.env.test?
      OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :sidekiq

    # 自作のvalidationを使う
    config.autoload_paths += %W(#{config.root}/app/validators)
  end
end
