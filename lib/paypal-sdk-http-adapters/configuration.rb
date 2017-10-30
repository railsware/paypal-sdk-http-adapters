module PayPal::SDK
  class << self
    attr_accessor :http_adapter_name

    def current_http_adapter
      load_http_adapter(http_adapter_name) unless http_adapters.key?(http_adapter_name)
      http_adapters.fetch(http_adapter_name)
    end

    def load_http_adapter(name)
      require "paypal-sdk/http_adapters/#{name}"
    end

    def register_http_adapter(name, klass)
      http_adapters[name] = klass
    end

    protected

    def http_adapters
      @http_adapters ||= {}
    end
  end

  self.http_adapter_name = :net_http
end
