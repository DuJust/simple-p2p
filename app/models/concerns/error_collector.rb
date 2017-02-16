module Concerns
  module ErrorCollector
    extend ActiveSupport::Concern

    def collect_error(*methods)
      methods.each do |method|
        obj = send(method) if respond_to?(method)
        next if !obj || obj.valid?
        obj.errors.full_messages.each { |msg| errors[method] << msg }
      end
    end
  end
end
