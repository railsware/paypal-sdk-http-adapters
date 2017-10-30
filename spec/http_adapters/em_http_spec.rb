require 'spec_helper'

RSpec.describe PayPal::SDK::HttpAdapters::EmHttp do
  subject { described_class.new(uri, proxy) }

  let(:uri) { URI.parse('https://example.com:8080/foo/bar') }

  context 'no proxy' do
    let(:proxy) { nil }

    specify do
      expect(subject).to be_kind_of(described_class)
      expect(subject.connection_options).to eq(
        tls: {}
      )
    end
  end

  context 'proxy given' do
    let(:proxy) { URI.parse('https://alice:secret@proxy.com:8181') }

    specify do
      expect(subject).to be_kind_of(described_class)
      expect(subject.connection_options).to eq(
        tls: {},
        proxy: {
          host: 'proxy.com',
          port: 8181,
          authorization: %w[alice secret]
        }
      )
    end
  end
end
