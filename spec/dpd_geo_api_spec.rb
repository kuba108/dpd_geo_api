# frozen_string_literal: true

RSpec.describe DpdGeoApi do
  let(:api_secret) { 'a2447d590f3d7705a7ef4353c6ff39fd' }
  let(:api_url) { 'https://geoapi.dpd.cz/v1' }
  let(:client) { DpdGeoApi::Client.new(api_secret, api_url) }

  it "has a version number" do
    expect(DpdGeoApi::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'initializes with correct api_secret and api_url' do
      expect(client.api_secret).to eq(api_secret)
      expect(client.api_url).to eq(api_url)
    end
  end

  describe '#me' do
    before do
      allow_any_instance_of(DpdGeoApi::RequestMaker).to receive(:get_request).and_return('response')
    end

    it 'calls the API method "/me"' do
      expect(client.me).to eq('response')
    end
  end
end
