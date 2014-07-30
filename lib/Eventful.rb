# Eventful.rb
# Eventful

# 20140730
# 0.5.0

require 'Stateful'
require_relative File.join('Eventful', 'ClassMethods')

module Eventful

  class << self

    def load_persistence_class_methods(klass)
      if defined?(ActiveRecord::Base) && klass < ActiveRecord::Base
        require_relative File.join('Eventful', 'ActiveRecord')
        klass.extend(Eventful::ActiveRecord::ClassMethods)
      else
        require_relative File.join('Eventful', 'Poro')
        klass.extend(Eventful::Poro::ClassMethods)
      end
    end

    def extended(klass)
      klass.extend(Stateful)
      klass.extend(Eventful::ClassMethods)
      load_persistence_class_methods(klass)
    end
    alias_method :included, :extended

  end # class << self

end
