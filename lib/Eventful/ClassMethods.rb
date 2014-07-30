# Eventful/ClassMethods.rb
# Eventful::ClassMethods

module Eventful
  module ClassMethods

    # memory resident
    def memory_run(frequency_in_seconds = 1, runtime_in_seconds = nil)
      if runtime_in_seconds
        expiry_time = Time.now + runtime_in_seconds
      end
      loop do
        break if runtime_in_seconds && Time.now >= expiry_time
        scheduled_run
        sleep frequency_in_seconds
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

    def run(frequency_in_seconds = nil, runtime_in_seconds = nil)
      if frequency_in_seconds
        memory_run(frequency_in_seconds, runtime_in_seconds)
      else
        scheduled_run
      end
    end

  end
end
