# Eventful/Poro/ClassMethods.rb
# Eventful::Poro::ClassMethods

require 'ObjectSpace/self.select_objects'

module Eventful
  module Poro
    module ClassMethods

      def active
        ObjectSpace.select_objects(self){|o| o.active?}
      end

    end
  end
end
