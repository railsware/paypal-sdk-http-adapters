require 'spec_helper'

RSpec.describe PayPal::SDK::HttpAdapters::NetHttp do
  subject { described_class.new(uri, proxy) }

  let(:uri) { URI.parse('https://example.com:8080/foo/bar') }

  context 'no proxy' do
    let(:proxy) { nil }

    specify do
      expect(subject).to be_kind_of(Net::HTTP)
      expect(subject.address).to eq('example.com')
      expect(subject.port).to eq(8080)
      expect(subject.proxy_address).to be_nil
      expect(subject.proxy_port).to be_nil
      expect(subject.proxy_user).to be_nil
      expect(subject.proxy_pass).to be_nil
    end
  end

  context 'proxy given' do
    let(:proxy) { URI.parse('https://alice:secret@proxy.com:8181') }

    specify do
      expect(subject).to be_kind_of(Net::HTTP)
      expect(subject.address).to eq('example.com')
      expect(subject.port).to eq(8080)
      expect(subject.proxy_address).to eq('proxy.com')
      expect(subject.proxy_port).to eq(8181)
      expect(subject.proxy_user).to eq('alice')
      expect(subject.proxy_pass).to eq('secret')
    end
  end
end
