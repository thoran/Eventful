# Eventful.rb
# Eventful

# 20140202
# 0.0.1

require 'Stateful'

module Eventful

  # memory resident
  def run_loop
    loop do
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
