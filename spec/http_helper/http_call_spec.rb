require 'spec_helper'

RSpec.describe PayPal::SDK::Core::Util::HTTPHelper, '.http_call' do
  subject do
    Class.new do
      include PayPal::SDK::Core::Util::HTTPHelper
    end.new.http_call(
      uri: request_uri,
      method: request_method,
      header: request_header,
      body: request_body
    )
  end

  let(:request_uri) do
    URI.parse('https://example.com:8080/api/resource.json?v=1')
  end
  let(:request_header) do
    {
      'User-Agent' => 'PayPalSDK',
      'X-Request-Version' => '1.0.0'
    }
  end
  let!(:request_stub) do
    WebMock.stub_request(
      request_method,
      'https://example.com:8080/api/resource.json?v=1'
    ).with(
      {
        headers: {
          'User-Agent' => 'PayPalSDK',
          'X-Request-Version' => '1.0.0'
        },
        body: request_body
      }
    ).to_return(
      status: 200,
      headers: {
        'Content-Length' => response_body.size,
        'X-Response-Version' => '2.0.0'
      },
      body: response_body
    )
  end

  let(:response_body) do
    {
      id: 101
    }.to_json
  end

  shared_context :get_method do
    context 'GET' do
      let(:request_method) { :get }
      let(:request_body) { nil }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['10'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq(
          '{"id":101}'
        )
        expect(request_stub).to have_been_requested
      end
    end
  end

  shared_context :head_method do
    context 'HEAD' do
      let(:request_method) { :head }
      let(:request_body) { nil }
      let(:response_body) { '' }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['0'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq('')
        expect(request_stub).to have_been_requested
      end
    end
  end

  shared_context :delete_method do
    context 'DELETE' do
      let(:request_method) { :delete }
      let(:request_body) { nil }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['10'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq(
          '{"id":101}'
        )
        expect(request_stub).to have_been_requested
      end
    end
  end

  shared_context :put_method do
    context 'PUT' do
      let(:request_method) { :put }
      let(:request_body) { 'foo=bar' }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['10'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq(
          '{"id":101}'
        )
        expect(request_stub).to have_been_requested
      end
    end
  end

  shared_context :post_method do
    context 'POST' do
      let(:request_method) { :post }
      let(:request_body) { 'foo=bar' }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['10'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq(
          '{"id":101}'
        )
        expect(request_stub).to have_been_requested
      end
    end
  end

  shared_context :patch_method do
    context 'PATCH' do
      let(:request_method) { :patch }
      let(:request_body) { 'foo=bar' }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['10'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq(
          '{"id":101}'
        )
        expect(request_stub).to have_been_requested
      end
    end
  end

  shared_context :options_method do
    context 'OPTIONS' do
      let(:request_method) { :options }
      let(:request_body) { 'foo=bar' }

      specify do
        expect(subject).to be_kind_of(Net::HTTPResponse)
        expect(subject.code).to eq('200')
        expect(subject.to_hash).to eq(
          'content-length' => ['10'],
          'x-response-version' => ['2.0.0']
        )
        expect(subject.body).to eq(
          '{"id":101}'
        )
        expect(request_stub).to have_been_requested
      end
    end
  end

  context 'net_http adapter' do
    before do
      PayPal::SDK.http_adapter_name = :net_http
      WebMock.disable!(except: [:net_http])
    end

    include_context :get_method
    include_context :head_method
    include_context :delete_method
    include_context :put_method
    include_context :post_method
    include_context :patch_method
    #include_context :options_method
  end

  context 'em_http adapter' do
    before do
      PayPal::SDK.http_adapter_name = :em_http
      WebMock.disable!(except: [:em_http_request])
    end

    include_context :get_method
    include_context :head_method
    include_context :delete_method
    include_context :put_method
    include_context :post_method
    include_context :patch_method
    include_context :options_method
  end
end
