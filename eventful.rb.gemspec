Gem::Specification.new do |spec|
  spec.name = 'eventful.rb'

  spec.version = '0.7.0'
  spec.date = '2019-08-02'

  spec.summary = "Automatically change state with Stateful state machines."
  spec.description = "By defining predicate methods which except for the addition of '?' matches a state machine event and then configuring an in memory or cron-based event loop, the state machine will be able to change state automatically."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/Eventful'
  spec.license = 'MIT'

  spec.files = Dir['lib/**/*.rb']
  spec.required_ruby_version = '>= 1.8.6'
end
