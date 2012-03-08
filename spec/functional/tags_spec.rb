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

    tags = subject.functions(:class => 'FlxSprite')
    tags.first.should be_an_instance_of(FlashDevelop::Tag)
    tags.first.full_package.should == 'org.flixel.FlxSprite'
    tags.length.should == 17
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
  end

  it 'should return nil for invalid tags' do
    tag = subject.variable('SOMETHING_THAT_DOESNT_EXIST')
    tag.should be_nil
  end

  it 'should accept file patterns for finding tags' do
    tag_in_class = subject.function('save', :file => 'src/org/flixel/plugin/photonstorm/FlxScreenGrab.as')
    tag_in_class.name.should == 'save'
    tag_in_class.function?.should == true

    tag_in_class = subject.find('save', :file => 'src/org/flixel/plugin/photonstorm/FlxScreenGrab.as')
    tag_in_class.name.should == 'save'
    tag_in_class.function?.should == true

    tag_in_class = subject.find('save', :package => 'org.flixel.plugin.photonstorm.*')
    tag_in_class.name.should == 'save'
    tag_in_class.function?.should == true

    tag_in_class = subject.find('save', :file => 'doesnt exists')
    tag_in_class.should be_false
  end

end
