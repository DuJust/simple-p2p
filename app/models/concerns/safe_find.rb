module Concerns
  module SafeFind
    extend ActiveSupport::Concern

    module ClassMethods
      def safe_find(method, klass, id_name, options = {})
        define_method(method) do
          variable_name = "@#{method}"

          unless instance_variable_defined?(variable_name)
            attribute = begin
              id = instance_variable_get(id_name)
              options[:with_lock] ? klass.lock.find(id) : klass.find(id)
            rescue ActiveRecord::RecordNotFound
            end
            instance_variable_set(variable_name, attribute)
          end

          instance_variable_get(variable_name)
        end
      end
    end
  end
end
