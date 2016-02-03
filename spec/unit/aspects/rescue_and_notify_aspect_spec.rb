require 'spec_helper'

describe CoAspects::Aspects::RescueAndNotifyAspect do
  class FakeError < RuntimeError
    attr_reader :newrelic_opts

    def initialize(message, newrelic_opts)
      super(message)
      @newrelic_opts = newrelic_opts
    end
  end

  before do
    stub_class('Target') do
      aspects_annotations!
      _rescue_and_notify
      def perform(work)
        fail 'An error has occured' unless work
        :success
      end
      _rescue_and_notify
      def perform_with_options
        fail FakeError.new('Message', {op: :val})
      end
    end
  end

  it 'notifies new relic if an error is raised' do
    expect(NewRelic::Agent).to receive(:notice_error)
      .with(kind_of(Exception), {})
    expect(Target.new.perform(false)).to eq(nil)
  end

  it 'notifies new relic with custom params if given' do
    expect(NewRelic::Agent).to receive(:notice_error)
      .with(kind_of(FakeError), {op: :val})
    expect(Target.new.perform_with_options).to eq(nil)
  end

  it 'does not notify new relic if there is no error' do
    expect(NewRelic::Agent).not_to receive(:notice_error)
    expect(Target.new.perform(true)).to eq(:success)
  end

  context 'with test mode enabled' do
    around do |example|
      CoAspects::Aspects::RescueAndNotifyAspect.enable_test_mode!
      example.run
      CoAspects::Aspects::RescueAndNotifyAspect.disable_test_mode!
    end

    it 'propagates the error if something is raised' do
      expect(NewRelic::Agent).not_to receive(:notice_error)
      expect{Target.new.perform(false)}.to raise_error(/error has occured/)
    end

    it 'does not notify new relic if there is no error' do
      expect(NewRelic::Agent).not_to receive(:notice_error)
      expect(Target.new.perform(true)).to eq(:success)
    end
  end
end
