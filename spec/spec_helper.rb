$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'co_aspects'

module Helpers
  def stub_class(name, &block)
    stub_const name, Class.new
    klass = name.constantize
    klass.class_eval(&block) if block
    klass
  end
end

RSpec.configure do |c|
  c.include Helpers
end
