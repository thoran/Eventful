# Eventful.rb
# Eventful

# 20140203
# 0.1.0

require 'Stateful'

module Eventful

  # memory resident
  def run_loop(frequency_in_seconds = 0)
    loop do
      sleep frequency_in_seconds
      run
    end
  end

  # scheduled
  def run
    self.active.all.each do |instance|
      instance.state.transitions.each do |transition|
        if instance.send("#{transition.event_name}?")
          instance.send("#{transition.event_name}")
        end
      end
    end
  end

end
