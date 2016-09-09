module Devise
  module Models
    module Pinfirmable
      extend ActiveSupport::Concern

      included do
        @skip_pinfirmation = false
        before_create :generate_confirmation_token
        after_commit :send_confirmation_instructions, on: :create
      end

      def confirm
        update_attribute(:pinfirmable_pin, nil)
      end

      def skip_pinfirmation!
        @skip_pinfirmation = true
      end

      protected

      def generate_confirmation_token
        pin = ""
        6.times { pin << SecureRandom.random_number(9).to_s }
        self.pinfirmable_pin = pin
      end

      def send_confirmation_instructions
        PinfirmableMailer.pin_email(self).deliver unless @skip_pinfirmation
      end
    end
  end
end
