module Censor
  class Base
    class << self

      attr_accessor :error_list

      def detect_errors(text, rates)
        raise ArgumentError, 'Error rates' unless rates.is_a? Array

        @error_list = []

        check_stopwords(text, Censor.config.rules, rates)

        @error_list.any?
      end

      def check_stopwords(text, rules, rates)
        replacement = ''
        rules.each do |category, rule_category|
          category_int = Integer(category)
          rule_category.each do |key, rule|
            if text.scan(rule).any?
              @error_list[category_int] ||= []
              @error_list[category_int] << {
                key: key,
                text: text
              }
            end
          end
        end
      end

    end
  end
end