# HTTP Adapters for PayPal SDK[![Build Status](https://travis-ci.org/railsware/paypal-sdk-http-adapters.svg?branch=master)](https://travis-ci.org/railsware/paypal-sdk-http-adapters)

This gem extends PayPal SDK and allows you to set specific http library.

Currently it supports two adapters:

* `:net_http` - Net::HTTP (default, blocking I/O)
* `:em_http` - EM::Http (non-blocking I/0)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paypal-sdk-http-adapters'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paypal-sdk-http-adapters

## NetHttp Adapter

```
PayPal::SDK.http_adapter_name = :net_http
```

This is default adapter that actually is very simple wrapper for standard `Net::HTTP`.

## EmHttp Adapter

```
PayPal::SDK.http_adapter_name = :em_http
```

This is adapter for `EM::Http` library.

When EventMachine is already running we assume that you are responsible for Fiber allocation.
You can add `Rack::FiberPool` to your application middleware and it automatically provides a Fiber for each incoming HTTP request.
It creates pool of Fibers and re-use fiber for each incoming HTTP request.
Also you can control the connection pool size.

## Authors

* [Andriy Yanko](http://ayanko.github.io)

## References

* https://github.com/paypal/PayPal-Ruby-SDK
* https://github.com/paypal/sdk-core-ruby
* https://github.com/igrigorik/em-http-request
* https://github.com/alebsack/rack-fiber_pool
