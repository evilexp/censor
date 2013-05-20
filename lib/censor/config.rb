module Censor
  class Config

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

    def rules
      strong_rules = {
        email: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/,
        site: /(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[a-z]{2,4}|museum|travel)/i
      }
      medium_rules = {
        phone: /([\(]?\d{0,3}[\)]?[\s]?[\-]?\d{3}[\s]?[\-]?\d{4}[\s]?[x]?\d*)/,
        skype: /skype|gmail/i
      }
      light_rules = {
        email_attempt: "/@/i"
      }

      { ALERT_RATES[:strong].to_s => strong_rules, ALERT_RATES[:medium].to_s => medium_rules, ALERT_RATES[:light].to_s => light_rules }
    end

    private

    def add_user_rules

    end

  end
end