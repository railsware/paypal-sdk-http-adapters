PayPal::SDK::Core::Util::HTTPHelper.class_eval do
  def new_http(uri)
    proxy = URI.parse(config.http_proxy) if config.http_proxy
    adapter_klass = PayPal::SDK.current_http_adapter
    adapter_klass.new(uri, proxy)
  end
end
