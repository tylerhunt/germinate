require File.join(%W(#{File.dirname(__FILE__)} .. spec_helper))

describe Germinate::Seed do
  it "should have an attribute accessor for the model" do
    Germinate::Seed.should respond_to(:model, :model=)
  end

  it "should have an attribute accessor for records" do
    Germinate::Seed.should respond_to(:records, :records=)
  end

  it "should have an attribute accessor for statuses" do
    Germinate::Seed.should respond_to(:statuses, :statuses=)
  end

  it "should have an attribute reader for the loaded seeds" do
    Germinate::Seed.should respond_to(:seeds)
  end

  it "should return a factory if it receives a method defined by Record" do
    Germinate::Record.send(:remove_const, :METHODS)
    Germinate::Record::METHODS = [:create]
    factory = mock('factory')
    Germinate::Factory.should_receive(:new).with(UserSeed, :create).and_return(factory)
    UserSeed.create do |user|
      user.should == factory
    end
  end

  describe "implementation" do
    it "should set the model attribute to the underlying model" do
      UserSeed.should_receive(:model=).with(User)
      Germinate::Seed.inherited(UserSeed)
    end

    it "should initialize the records set with an empty array" do
      UserSeed.should_receive(:records=).with([])
      Germinate::Seed.inherited(UserSeed)
    end

    it "should initialize the statuses set with an empty hash" do
      UserSeed.should_receive(:statuses=).with({})
      Germinate::Seed.inherited(UserSeed)
    end

    it "should add itself to the seeds set" do
      Germinate::Seed.seeds.should include(UserSeed)
    end

    it "should keep the seeds list unique" do
      seeds = mock('seeds')
      seeds.should_receive(:<<)
      seeds.should_receive(:uniq!)
      Germinate::Seed.instance_variable_set('@seeds', seeds)
      Germinate::Seed.inherited(UserSeed)
    end

    describe "accessors" do
      it "should provide access to the underlying model" do
        UserSeed.model.should == User
      end

      it "should provide access to the records set" do
        UserSeed.records.should be_empty
      end

      it "should provide access to the statuses set" do
        UserSeed.statuses.should be_empty
      end
    end
  end
end
