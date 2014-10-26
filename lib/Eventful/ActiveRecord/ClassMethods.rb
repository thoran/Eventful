# Eventful/ActiveRecord/ClassMethods.rb
# Eventful::ActiveRecord::ClassMethods

module Eventful
  module ActiveRecord
    module ClassMethods

      def active
        if self.column_names.include?('active')
          where(active: true)
        else
          self.all.select{|o| o.active?}
        end
      end

    end
  end
end
