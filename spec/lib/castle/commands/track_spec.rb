# frozen_string_literal: true

describe Castle::Commands::Track do
  subject(:instance) { described_class.new(context) }

  let(:context) { { test: { test1: '1' } } }
  let(:default_payload) { { event: '$login.track' } }

  describe '#build' do
    subject(:command) { instance.build(payload) }

    context 'simple merger' do
      let(:payload) { default_payload.merge({ context: { test: { test2: '1' } } }) }
      let(:command_data) do
        default_payload.merge({ context: { test: { test1: '1', test2: '1' } } })
      end

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end

    context 'user_id' do
      let(:payload) { default_payload.merge({ user_id: '1234' }) }
      let(:command_data) do
        default_payload.merge({ user_id: '1234', context: context })
      end

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end

    context 'properties' do
      let(:payload) { default_payload.merge({ properties: { test: '1' } }) }
      let(:command_data) do
        default_payload.merge({ properties: { test: '1' }, context: context })
      end

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end

    context 'traits' do
      let(:payload) { default_payload.merge({ traits: { test: '1' } }) }
      let(:command_data) do
        default_payload.merge({ traits: { test: '1' }, context: context })
      end

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end

    context 'active true' do
      let(:payload) { default_payload.merge({ context: { active: true } }) }
      let(:command_data) do
        default_payload.merge({ context: context.merge(active: true) })
      end

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end

    context 'active false' do
      let(:payload) { default_payload.merge({ context: { active: false } }) }
      let(:command_data) do
        default_payload.merge({ context: context.merge(active: false) })
      end

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end

    context 'active string' do
      let(:payload) { default_payload.merge({ context: { active: 'string' } }) }
      let(:command_data) { default_payload.merge({ context: context }) }

      it { expect(command.method).to be_eql(:post) }
      it { expect(command.path).to be_eql('track') }
      it { expect(command.data).to be_eql(command_data) }
    end
  end

  describe '#validate!' do
    subject(:validate!) { instance.build(payload) }

    context 'event not present' do
      let(:payload) { {} }

      it do
        expect do
          validate!
        end.to raise_error(Castle::InvalidParametersError, 'event is missing or empty')
      end
    end

    context 'event present' do
      let(:payload) { { event: '$login.track' } }

      it { expect { validate! }.not_to raise_error }
    end
  end
end
