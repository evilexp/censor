module Censor
  class Config

    DEFAULT_WHITELIST = File.dirname(__FILE__) + '/../../config/whitelist.yml'
    DEFAULT_BLACKLIST = File.dirname(__FILE__) + '/../../config/blacklist.yml'

    ALERT_RATES = {
      strong: 0,
      medium: 1,
      light: 2
    }

    def initialize(with_user_rules = false)
      if with_user_rules
        add_user_rules
      end
    end

    def whitelist
      @whitelist ||= DEFAULT_WHITELIST
    end

    def whitelist=(value)
      @whitelist = value == :default ? DEFAULT_WHITELIST : value
    end

    def blacklist
      @blacklist ||= DEFAULT_BLACKLIST
    end

    def blacklist=(value)
      @blacklist = value == :default ? DEFAULT_BLACKLIST : value
    end

    def rules
      strong_rules = {
        email: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/,
        site: /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[a-z]{2,4}|museum|travel)/i
      }
      medium_rules = {
        phone: /([\(]?\d{0,3}[\)]?[\s]?[\-]?\d{3}[\s]?[\-]?\d{4}[\s]?[x]?\d*)/
      }
      light_rules = {
        email_attempt: /@/i
      }

      { ALERT_RATES[:strong].to_s => strong_rules, ALERT_RATES[:medium].to_s => medium_rules, ALERT_RATES[:light].to_s => light_rules }
    end

    private

    def add_user_rules

    end

  end
end