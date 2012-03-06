require File.expand_path('spec/spec_helper')

describe FlashDevelop::Tags do
  before(:all) do
    subject.instance.tags_file = 'spec/fixtures/tags/flixel-game'
  end

  subject { FlashDevelop::Tags }

  it 'load tags file' do
    subject.tags.length.should == open('spec/fixtures/tags/flixel-game').read.length
  end

  it 'should identify a class tag' do
    tag = subject.klass('FlxSprite')
    tag.should be_an_instance_of(FlashDevelop::Tag)
    tag.name.should == 'FlxSprite'
    tag.class?.should == true
  end

  it 'should identify a function tag' do
    tag = subject.function('saveSharedContent')
    tag.should be_an_instance_of(FlashDevelop::Tag)
    tag.name.should == 'saveSharedContent'
    tag.function?.should == true
  end

  it 'should identify a variable tag' do
    tag = subject.variable('scale')
    tag.should be_an_instance_of(FlashDevelop::Tag)
    tag.name.should == 'scale'
    tag.variable?.should == true

    # in class
    tag_in_class = subject.function('save', 'src/org/flixel/plugin/photonstorm/FlxScreenGrab.as')
    tag_in_class.name.should == 'save'
    tag_in_class.function?.should == true

    tag_in_class = subject.find('save', 'src/org/flixel/plugin/photonstorm/FlxScreenGrab.as')
    tag_in_class.name.should == 'save'
    tag_in_class.function?.should == true
  end

  it 'should return nil for invalid tags' do
    tag = subject.variable('SOMETHING_THAT_DOESNT_EXIST')
    tag.should be_nil

    # in class
  end

end
