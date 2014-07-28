# Eventful.rb
# Eventful

# 20140112, 0202
# 0.0.0

require 'Stateful'

module Eventful

  # memory resident
  def run
    loop do
      self.active.all.each do |instance|
        instance.state.transitions.each do |transition|
          if instance.send("#{transition.event_name}?")
            instance.send("#{transition.event_name}")
          end
        end
      end
    end
  end

  # scheduled
  def run
    self.active.all.each do |instance|

    end
  end

end
