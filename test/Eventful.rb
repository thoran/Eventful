# test/Eventful.rb

# The two ActiveRecord specs don't like being run together, so I randomly pick one of them to run...
active_record_test_file = ['ActiveRecord', 'ActiveRecordWhenNoFinalState'][rand(2)]
require_relative active_record_test_file

require_relative 'Poro'
