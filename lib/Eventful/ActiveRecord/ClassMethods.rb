# Eventful/ActiveRecord/.rb
# Eventful::ActiveRecord::ClassMethods

module Eventful
  module ActiveRecord
    module ClassMethods

      def active
        self.all.select{|o| o.active?}
      end

    end
  end
end
