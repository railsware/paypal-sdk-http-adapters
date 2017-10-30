require 'net/http'

module PayPal::SDK
  module HttpAdapters
    class NetHttp
      class << self
        def new(uri, proxy)
          if proxy
            Net::HTTP.new(
              uri.host,
              uri.port,
              proxy.host,
              proxy.port,
              proxy.user,
              proxy.password
            )
          else
            Net::HTTP.new(
              uri.host,
              uri.port
            )
          end
        end
      end
    end
  end

  self.register_http_adapter :net_http, HttpAdapters::NetHttp
end
