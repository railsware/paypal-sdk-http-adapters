require 'em-http'
require 'fiber'

module PayPal::SDK
  module HttpAdapters
    class EmHttp
      attr_reader :connection_options

      def initialize(uri, proxy)
        @uri = uri
        @connection_options = {
          tls: {}
        }
        @connection_options[:proxy] = {
          host: proxy.host,
          port: proxy.port,
          authorization: [proxy.user, proxy.password]
        } if proxy
      end

      def open_timeout=(value)
        @connection_options[:connect_timeout] = value
      end

      def read_timeout=(value)
        @connection_options[:inactivity_timeout] = value
      end

      def use_ssl=(value)
        true
      end

      def ca_file=(value)
        @connection_options[:tls][:cert_chain_file] = value
      end

      def verify_mode=(value)
        @connection_options[:tls][:verify_peer] = (value > 0)
      end

      def ssl_version=(value)
        @connection_options[:tls][:ssl_version] = value
      end

      def cert=(value)
        raise NotImplementedError, "cert=#{value}" if value
      end

      def key=(value)
        raise NotImplementedError, "key=#{value}" if value
      end

      #########################################################################

      %i[get head delete].each do |method|
        define_method method do |path, header|
          request(method, path, header, nil)
        end
      end

      %i[put post patch options].each do |method|
        define_method method do |path, body, header|
          request(method, path, header, body)
        end
      end

      def request(method, path, header, body)
        within_session do
          uri = URI.parse(path)

          client = run_request(@connection, method,
            path: uri.path,
            query: uri.query,
            head: header,
            body: body
          )

          if client.error
            raise client.error
          else
            build_response(client)
          end
        end
      end

      def start
        raise 'session is already started' if @started

        begin
          @started = true
          @connection = EM::HttpRequest.new(@uri, @connection_options)

          within_reactor do
            yield(self)
          end
        ensure
          @connection = nil
          @started = nil
        end
      end

      def started?
        @started
      end

      protected

      def within_session
        if started?
          yield
        else
          start do
            yield
          end
        end
      end

      def within_reactor
        result = nil

        if EM.reactor_running?
          result = yield
        else
          EM.run do
            Fiber.new do
              result = yield
              EM.stop
            end.resume
          end
        end

        result
      end

      def run_request(connection, method, options)
        connection.setup_request(method, options).tap do |client|
          unless client.error
            fiber = Fiber.current
            client.callback { fiber.resume(client) }
            client.errback { fiber.resume(client) }
            Fiber.yield
          end
        end
      end

      def build_response(client)
        klass = Net::HTTPResponse.send(:response_class,
          client.response_header.status.to_s
        )

        response = klass.new(
          client.response_header.http_version,
          client.response_header.status.to_s,
          client.response_header.http_reason
        )

        client.response_header.raw.each do |k, v|
          response.add_field(k, v)
        end

        response.body = client.response

        response.instance_variable_set :@read, true

        response
      end
    end
  end

  self.register_http_adapter :em_http, HttpAdapters::EmHttp
end
