module Censor
  class Base
    class << self

      attr_accessor :error_list

      def whitelist
        @whitelist ||= parse_config_content(Censor.config.whitelist)
      end

      def whitelist=(value)
        @whitelist = value == :default ? parse_config_content(Censor::Config.new.whitelist) : value
      end

      def blacklist
        @blacklist ||= parse_config_content(Censor.config.blacklist)
      end

      def blacklist=(value)
        @blacklist = value == :default ? parse_config_content(Censor::Config.new.blacklist) : value
      end

      def detect_errors(text, rates)
        raise ArgumentError, 'Error rates' unless rates.is_a? Array

        @error_list = []

        check_stopwords(text, Censor.config.rules, rates)

        @error_list.any?
      end

      def check_stopwords(text, rules, rates)
        rules.each do |category, rule_category|
          category_int = Integer(category)
          rule_category.each do |key, rule|
            errors = text.scan(rule)
            if (errors.any? && !whitelist_include?(errors))
              add_error(category_int, key, rule, text)
            end
          end
        end

        blacklist.each do |error|
          rule = /\b#{error}\b/i
          error_list = text.scan(rule)
          errors = error_list unless whitelist_include?(error_list)

          if errors.any?
            add_error(Censor::Config::ALERT_RATES[:medium], 'blacklist', rule, text)
          end
        end
      end

      private

      def add_error(category, key, rule, text, replacement = '')
        @error_list[category] ||= []
        @error_list[category] << {
            key: key,
            text: text.gsub(rule, replacement)
        }
      end

      def parse_config_content(list)
        YAML.load_file( list.to_s )
      end

      def whitelist_include?(errors)
        errors.each do |error|
          whitelist.each do |pass|
            return(true) if error =~ /\b#{pass}\b/i
          end
        end

        false
      end

    end
  end
end