# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'pry-rails'
require 'shoulda'
require 'test/unit'

require 'active_model'
require 'censor'
require 'censor/active_model'

module Dummy
  class BaseModel
    include ActiveModel::Validations

    attr_accessor :body

    def initialize(attr_names)
      attr_names.each{ |k,v| send("#{k}=", v) }
    end
  end
end

class Test::Unit::TestCase
end
