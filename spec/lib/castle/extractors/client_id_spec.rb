# frozen_string_literal: true

describe Castle::Extractors::ClientId do
  subject(:extractor) { described_class.new(request, cookies) }

  let(:client_id) { 'abcd' }
  let(:cookies) { request.cookies }
  let(:request) { Rack::Request.new(env) }
  let(:env) do
    Rack::MockRequest.env_for('/', headers)
  end

  context 'with client_id' do
    let(:headers) do
      {
        'HTTP_X_FORWARDED_FOR' => '1.2.3.4',
        'HTTP_COOKIE' => "__cid=#{client_id};other=efgh"
      }
    end

    it do
      expect(extractor.call('__cid')).to eql(client_id)
    end
  end

  context 'with X-Castle-Client-Id header' do
    let(:headers) do
      {
        'HTTP_X_FORWARDED_FOR' => '1.2.3.4',
        'HTTP_X_CASTLE_CLIENT_ID' => client_id
      }
    end

    it 'appends the client_id' do
      expect(extractor.call('__cid')).to eql(client_id)
    end
  end

  context 'allow cookies to be undefined' do
    let(:cookies) { nil }
    let(:headers) { {} }

    it do
      expect(extractor.call('__cid')).to eql('')
    end
  end
end
