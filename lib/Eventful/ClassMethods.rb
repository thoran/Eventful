# Eventful/ClassMethods.rb
# Eventful::ClassMethods

require 'ObjectSpace/self.select_objects'

module Eventful
  module ClassMethods

    def active
      ObjectSpace.select_objects(self){|o| o.active?}
    end

    # memory resident
    def memory_run(frequency_in_seconds = 0)
      loop do
        sleep frequency_in_seconds
        run
      end
    end

    # scheduled
    def scheduled_run
      self.active.each do |instance|
        instance.transitions.each do |transition|
          if instance.send("#{transition.event_name}?")
            instance.send("#{transition.event_name}")
          end
        end
      end
    end

    def run(frequency_in_seconds = nil)
      if frequency_in_seconds
        memory_run(frequency_in_seconds)
      else
        scheduled_run
      end
    end

  end
end
