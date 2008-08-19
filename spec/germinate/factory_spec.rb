require File.join(%W(#{File.dirname(__FILE__)} .. spec_helper))

describe Germinate::Factory do
  before(:each) do
    @methods = [:id, :name, :city_and_state]
    @seed = mock('seed')
    @seed.stub!(:records).and_return([])
    @factory = Germinate::Factory.new(@seed, :create)
    @record = mock('record')
    Germinate::Record.stub!(:new).and_return(@record)
  end

  it "should respond to any arbitrary method call with a new record" do
    @methods.each do |method|
      @factory.send(method).should == @record
    end
  end

  it "should create new records using the invoked method as the key" do
    @methods.each do |method|
      Germinate::Record.should_receive(:new).with(@seed, :create, method).and_return(@record)
      @factory.send(method)
    end
  end

  it "should add each generated record to the records set on the seed" do
    records = mock('records')
    records.should_receive(:<<).exactly(@methods.length).with(@record)
    @seed.should_receive(:records).exactly(@methods.length).and_return(records)

    @methods.each do |method|
      @factory.send(method)
    end
  end
end
