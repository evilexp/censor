if defined?(ActiveModel)
  module ActiveModel
    module Validations
      class CensorValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          record.errors.add(attribute, options[:message] || 'Bad data') if Censor.detect_errors(value, options[:rates] || [])
        end
      end
    end
  end
end