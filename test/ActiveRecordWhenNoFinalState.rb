# test/ActiveRecordWhenNoFinalState.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'active_record'
require 'pg'
require 'Eventful'

class CreateTableActiveRecordMachines2 < ActiveRecord::Migration

  def change
    create_table :active_record_machine2s do |t|
      t.string :current_state
    end
  end

end

class ActiveRecordMachine2 < ActiveRecord::Base

  include Eventful

  initial_state :initial_state do
    on :an_event => :another_state
  end

  state :another_state do
    on :another_event => :yet_another_state
  end

  state :yet_another_state do
    on :yet_another_event => :another_state
  end

end

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'test'
)
unless ActiveRecord::Base.connection.tables.include?('active_record_machine2s')
  CreateTableActiveRecordMachines2.new.change
end
if ActiveRecord::Base.connection.tables.include?('active_record_machine2s')
  ActiveRecordMachine2.delete_all
end

describe Eventful do

  let(:machine2){ActiveRecordMachine2.create}

  before do
    ActiveRecordMachine2.delete_all
  end

  it "must have successfully extended the receiver class with Stateful methods" do
    machine2.class.methods.include?(:stateful_states).must_equal true
  end

  it "must have successfully extended the receiver class with Eventful methods" do
    machine2.class.methods.include?(:active).must_equal true
  end

  context "only an_event? is true" do

    before do
      class ActiveRecordMachine2
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
      machine2.current_state
      ActiveRecordMachine2.active.size.must_equal 1
    end

    it "must know whether an event has occurred" do
      machine2.an_event?.must_equal true
    end

    it "must know whether an event has not occurred" do
      machine2.another_event?.must_equal false
      machine2.yet_another_event?.must_equal false
    end

    it "must automatically trigger state changes" do
      machine2.current_state
      ActiveRecordMachine2.run
      machine2.reload.current_state.name.must_equal :another_state
    end
  end

  context "an_event? and another_event? are true" do

    before do
      class ActiveRecordMachine2
        def an_event?
          true
        end

        def another_event?
          true
        end

        def yet_another_event?
          false
        end
      end
    end

    it "must know which instances are active (ie. not in a final state)" do
      machine2.current_state
      ActiveRecordMachine2.active.size.must_equal 1
    end

    it "must know whether an event has occurred" do
      machine2.an_event?.must_equal true
      machine2.another_event?.must_equal true
    end

    it "must know whether an event has not occurred" do
      machine2.yet_another_event?.must_equal false
    end

    it "must automatically trigger state changes" do
      machine2.current_state
      2.times{ActiveRecordMachine2.run}
      machine2.reload.current_state.name.must_equal :yet_another_state
    end
  end

  context "frequency_in_seconds and runtime_in_seconds given" do

    before do
      class ActiveRecordMachine2
        def an_event?
          true
        end

        def another_event?
          true
        end

        def yet_another_event?
          true
        end
      end
    end

    it "must run for no longer than the specified runtime_in_seconds" do
      start_time = Time.now
      ActiveRecordMachine2.run(2, 10) # Run every 2 seconds for not more than 10 seconds.
      finish_time = Time.now
      run_time = finish_time - start_time
      run_time.must_be_close_to 10, 0.1
    end
  end

end
