# test/ActiveRecord.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'active_record'
require 'pg'
require 'Eventful'

class CreateTableActiveRecordMachines < ActiveRecord::Migration

  def change
    create_table :active_record_machines do |t|
      t.string :current_state
      t.boolean :active
    end
  end

end

class ActiveRecordMachine < ActiveRecord::Base

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

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'test'
)
unless ActiveRecord::Base.connection.tables.include?('active_record_machines')
  CreateTableActiveRecordMachines.new.change
end
if ActiveRecord::Base.connection.tables.include?('active_record_machines')
  ActiveRecordMachine.delete_all
end

describe Eventful do

  let(:machine){ActiveRecordMachine.create}

  it "must have successfully extended the receiver class with Stateful methods" do
    machine.class.methods.include?(:stateful_states).must_equal true
  end

  it "must have successfully extended the receiver class with Eventful methods" do
    machine.class.methods.include?(:active).must_equal true
  end

  context "only an_event? is true" do
    before do
      class ActiveRecordMachine
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
      ActiveRecordMachine.delete_all
    end

    it "must know which instances are active (ie. not in a final state)" do
      ActiveRecordMachine.create
      ActiveRecordMachine.active.size.must_equal 1
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
      ActiveRecordMachine.run
      machine.reload.current_state.name.must_equal :next_state
    end
  end

  context "an_event? and yet_another_event? are true" do
    before do
      class ActiveRecordMachine
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
      ActiveRecordMachine.delete_all
    end

    it "must know which instances are active (ie. not in a final state)" do
      ActiveRecordMachine.create
      ActiveRecordMachine.active.size.must_equal 1
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
      ActiveRecordMachine.run
      machine.reload.current_state.name.must_equal :final_state
    end
  end

  context "frequency_in_seconds and runtime_in_seconds given" do
    before do
      class Machine
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
      ActiveRecordMachine.run(2, 10) # Run every 2 seconds for not more than 10 seconds.
      finish_time = Time.now
      run_time = finish_time - start_time
      run_time.must_be_close_to 10, 0.1
    end
  end

end
