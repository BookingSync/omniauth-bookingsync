module OmniAuth
  module BookingSync
    class Identifier
      attr_reader :identifier

      def initialize(identifier)
        @identifier = identifier
      end

      def value
        casted_value = identifier.to_i
        casted_value > 0 ? casted_value : nil
      end

      def valid?
        value != nil
      end
    end
  end
end
