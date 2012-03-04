require File.expand_path('spec/spec_helper')

describe FlashDevelop::Tags do
  subject { FlashDevelop::Tags }

  it 'load tags file' do
    subject.tags.should == open('tags').read
    puts subject.klass('Buffer').inspect
  end
end
