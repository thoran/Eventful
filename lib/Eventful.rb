# Eventful.rb
# Eventful

# 20140203
# 0.2.0

require 'Stateful'

module Eventful

  # memory resident
  def memory_run(frequency_in_seconds = 0)
    loop do
      sleep frequency_in_seconds
      run
    end
  end

  # scheduled
  def scheduled_run
    self.active.all.each do |instance|
      instance.state.transitions.each do |transition|
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
