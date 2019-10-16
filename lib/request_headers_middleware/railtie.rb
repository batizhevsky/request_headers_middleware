# frozen_string_literal: true

module RequestHeadersMiddleware
  # The Railtie triggering a setup from RAILs to make it configurable
  class Railtie < ::Rails::Railtie
    config.request_headers_middleware = ::ActiveSupport::OrderedOptions.new
    config.request_headers_middleware.blacklist = []
    config.request_headers_middleware.callbacks = []

    initializer 'request_headers_middleware.insert_middleware' do |app|
      if ActionDispatch.const_defined? :RequestId
        app.config.middleware.insert_after ActionDispatch::RequestId, RequestHeadersMiddleware::Middleware
      else
        app.config.middleware.insert_after Rack::MethodOverride, RequestHeadersMiddleware::Middleware
      end

      app.config.after_initialize do
        RequestHeadersMiddleware.setup(app.config.request_headers_middleware)
      end
    end
  end
end
