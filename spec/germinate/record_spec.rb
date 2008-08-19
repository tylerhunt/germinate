require File.join(%W(#{File.dirname(__FILE__)} .. spec_helper))

describe Germinate::Record do
  before(:each) do
    @record = Germinate::Record.new(UserSeed, :create, :id, 1)
  end

  it "should define the available action methods" do
    [:create, :update, :create_or_update].each do |method|
      Germinate::Record::METHODS.should include(method)
    end
  end

  it "should privately respond to all of the specified action methods" do
    Germinate::Record::METHODS.each do |method|
      @record.private_methods.should include(method.to_s)
    end
  end

  it "should allow additional attributes to be specified and return self" do
    @record.instance_variable_get('@attributes').should be_nil
    @record.with(attributes = { :name => 'Test' }).should == @record
    @record.instance_variable_get('@attributes').should == attributes
  end

  it "should have an execute method that invokes the record's method" do
    @record.should_receive(:send).with(:create)
    @record.execute
  end

  describe "actions" do
    before(:each) do
      @user = mock('user')
      @user.stub!(:id=)
      @user.stub!(:attributes=)
      @user.stub!(:save!)
    end

    describe "an action in general", :shared => true do
      it "should save the record" do
        @user.should_receive(:save!)
      end

      it "should set the key on the new record" do
        @user.should_receive(:id=).with(1)
      end

      it "should set the attributes on the new record" do
        @user.should_receive(:attributes=).with(nil)
      end
    end

    describe "create" do
      describe "with success" do
        before(:each) do
          User.stub!(:find_by_id).and_return(nil)
          User.stub!(:new).and_return(@user)
        end

        it_should_behave_like "an action in general"

        it "should check for an existing record" do
          User.should_receive(:find_by_id).with(1).and_return(nil)
        end

        it "should create a new record" do
          User.should_receive(:new).and_return(@user)
        end

        it "should save the new record" do
          @user.should_receive(:save!)
        end

        it "should return the new record" do
          @after = lambda { |record| record.should == @user }
        end

        it "should set the status to :created" do
          @after = lambda { @record.status.should == :created }
        end

        after(:each) do
          record = @record.send(:create)
          @after.call(record) if @after
        end
      end

      it "should raise ActiveRecord::RecordNotSaved if the record exists" do
        User.should_receive(:find_by_id).with(1).and_return(@user)
        lambda { @record.send(:create) }.should raise_error(ActiveRecord::RecordNotSaved)
      end
    end

    describe "update" do
      describe "with success" do
        before(:each) do
          User.stub!(:find_by_id).and_return(@user)
        end

        it_should_behave_like "an action in general"

        it "should find an existing record" do
          User.should_receive(:find_by_id).with(1).and_return(@user)
        end

        it "should not create a new record" do
          User.should_not_receive(:new)
        end

        it "should save the updated record" do
          @user.should_receive(:save!)
        end

        it "should return the updated record" do
          @after = lambda { |record| record.should == @user }
        end

        it "should set the status to :update" do
          @after = lambda { @record.status.should == :updated }
        end

        after(:each) do
          record = @record.send(:update)
          @after.call(record) if @after
        end
      end

      it "should raise ActiveRecord::RecordNotFound if the record doesn't exist" do
        User.should_receive(:find_by_id).with(1).and_return(nil)
        lambda { @record.send(:update) }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "create or update" do
      before(:each) do
        User.stub!(:find_by_id).and_return(@user)
      end

      it_should_behave_like "an action in general"

      describe "with successful update" do
        it "should try to update the record" do
          @record.should_receive(:update)
          @record.should_not_receive(:create)
        end

        it "should return the updated record" do
          @after = lambda { |record| record.should == @user }
        end

        it "should set the status to :updated" do
          @after = lambda { @record.status.should == :updated }
        end
      end

      describe "with failed update" do
        before(:each) do
          User.stub!(:find_by_id).and_return(nil)
          User.stub!(:new).and_return(@user)
          @record.should_receive(:update).and_raise(ActiveRecord::RecordNotFound)
        end

        it "should try to create the record" do
          @record.should_receive(:create)
        end

        it "should return the created record" do
          @after = lambda { |record| record.should == @user }
        end

        it "should set the status to :created" do
          @after = lambda { @record.status.should == :created }
        end
      end

      after(:each) do
        record = @record.send(:create_or_update)
        @after.call(record) if @after
      end
    end
  end

  describe "update" do
  end

  describe "create or update" do
  end
end
