require 'censor/base'
require 'censor/config'

if defined?(ActiveModel)
  require 'censor/active_model'
end

module Censor extend self

  attr_accessor :config

  def configure(with_user_rules = false)
    @config = Config.new(with_user_rules)
  end

  def config
    @config ||= Config.new
  end

  def detect_errors(text, rates)
    Censor::Base.detect_errors(text, rates)
  end

end
