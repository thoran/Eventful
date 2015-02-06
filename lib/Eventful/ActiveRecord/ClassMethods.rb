# Eventful/ActiveRecord/ClassMethods.rb
# Eventful::ActiveRecord::ClassMethods

module Eventful
  module ActiveRecord
    module ClassMethods

      def active
        final_state_names = stateful_states.final_states.collect(&:name).collect(&:to_s)
        final_state_names_with_empty = (final_state_names.empty? ? '' : final_state_names)
        where('current_state NOT IN (?)', final_state_names_with_empty).all
      end

    end
  end
end
