require File.expand_path('spec/spec_helper')

describe 'Lexic' do

  context FlashDevelop::Word do
    subject {FlashDevelop::Word}

    it "should identify a class" do
      word = subject.new("Something")
      word.class?.should be_true
      word.const?.should be_false
      word.instance?.should be_false
    end

    it "should identify a constant" do
      word = subject.new("CONSTANT")
      word.class?.should be_false
      word.const?.should be_true
      word.instance?.should be_false
    end

    it "should identify a instance" do
      word = subject.new("something")
      word.class?.should be_false
      word.const?.should be_false
      word.instance?.should be_true

      word = subject.new("somethingCamelCased")
      word.class?.should be_false
      word.const?.should be_false
      word.instance?.should be_true
    end
  end

  context FlashDevelop::Statement do
    subject {FlashDevelop::Statement}

    it "should identify functions and it's arguments" do
      statement = subject.new("functionName", "instance.functionName(firstArg,", "\t\tsomething.functionName(hello, other);")
      statement.function.should == {:name => 'functionName', :args => 'hello, other'}
    end
  end

  context FlashDevelop::Sentence do

  end

  context FlashDevelop::Word do

  end
end
