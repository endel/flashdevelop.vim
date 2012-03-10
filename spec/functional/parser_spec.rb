require File.expand_path('spec/spec_helper')

describe FlashDevelop::Parser do
  context FlashDevelop::Parser::Package do
    subject {FlashDevelop::Parser::Package}

    it "should get class name, giving full package" do
      subject.class_name('com.flashdevelop.ClassName').should == 'ClassName'
    end
  end
end
