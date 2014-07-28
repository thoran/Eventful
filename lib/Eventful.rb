# Eventful.rb
# Eventful

# 20140617
# 0.3.0

require 'Stateful'
require_relative File.join('Eventful', 'ClassMethods')

module Eventful

  class << self

    def extended(klass)
      klass.extend(Stateful)
      klass.extend(Eventful::ClassMethods)
    end
    alias_method :included, :extended

  end # class << self

end
