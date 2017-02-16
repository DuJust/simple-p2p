module Concerns
  module MoneyFormat
    extend ActiveSupport::Concern

    included do |base|
      base.include ActionView::Helpers::NumberHelper
    end

    module ClassMethods
      def money_format(*methods)
        methods.each do |method|
          define_method(method) do
            number_with_precision(object.send(method), precision: 2)
          end
        end
      end
    end
  end
end
