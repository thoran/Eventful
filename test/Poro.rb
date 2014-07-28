# test/Poro.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Eventful'

class Machine

  include Eventful

  initial_state :initial_state do
    on :an_event => :next_state
    on :another_event => :final_state
  end

  state :next_state do
    on :yet_another_event => :final_state
  end

  final_state :final_state

end

describe Eventful do

  let(:machine){Machine.active.first || Machine.new}

  it "must have successfully extended the receiver class with Stateful methods" do
    machine.class.methods.include?(:stateful_states).must_equal true
  end

  it "must have successfully extended the receiver class with Eventful methods" do
    machine.class.methods.include?(:active).must_equal true
  end

  context "only an_event? is true" do
    before do
      class Machine
        def an_event?
          true
        end

        def another_event?
          false
        end

        def yet_another_event?
          false
        end
      end
    end

    it "must know which instances are active (ie. not in a final state)" do
      machine
      Machine.active.size.must_equal 1
    end

    it "must know whether an event has occurred" do
      machine.an_event?.must_equal true
    end

    it "must know whether an event has not occurred" do
      machine.another_event?.must_equal false
      machine.yet_another_event?.must_equal false
    end

    it "must automatically trigger state changes" do
      machine
      Machine.run
      machine.current_state.name.must_equal :next_state
    end
  end

  context "an_event? and yet_another_event? are true" do

    before do
      class Machine
        def an_event?
          true
        end

        def another_event?
          false
        end

        def yet_another_event?
          true
        end
      end
    end

    it "must know which instances are active (ie. not in a final state)" do
      machine
      Machine.active.size.must_equal 1
    end

    it "must know whether an event has occurred" do
      machine.an_event?.must_equal true
      machine.yet_another_event?.must_equal true
    end

    it "must know whether an event has not occurred" do
      machine.another_event?.must_equal false
    end

    it "must automatically trigger state changes" do
      machine.current_state = :next_state
      Machine.run
      machine.current_state.name.must_equal :final_state
    end
  end

end
