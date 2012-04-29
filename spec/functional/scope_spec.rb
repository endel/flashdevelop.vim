require File.expand_path('spec/spec_helper')

describe FlashDevelop::Scope do
  subject { FlashDevelop::Scope.new }

  it 'should have a valid buffer' do
    VIM::Buffer.load('ArrayUtil.as')
    $curbuf.name.index("spec/fixtures/buffer/ArrayUtil.as").should >= 0
    $curbuf.count.should == 213
    $curbuf[1].should == "/*"
    $curbuf[213].should == "}"
  end

  it 'should identify import and package statements' do
    VIM::Buffer.load('ArrayUtil.as')
    subject.reindex_headers!
    subject.imports.should be_empty
    subject.package.should == 'com.adobe.utils'
    subject.package_imported?('com.something.ClassName').should be_false

    VIM::Buffer.load('MD5.as')
    subject.reindex_headers!
    subject.imports.should == ["com.adobe.utils.IntUtil", "flash.utils.ByteArray"]
    subject.package.should == 'com.adobe.crypto'
    subject.package_imported?('com.adobe.utils.IntUtil').should be_true
    subject.package_imported?('flash.utils.ByteArray').should be_true
    subject.package_imported?('com.adobe.utils.Something').should be_false

    VIM::Buffer.load('FlixelMain.as')
    subject.reindex_headers!
    subject.imports.should == ['flash.display.BlendMode', 
                               'flash.display.Sprite',
                               'flash.geom.Matrix',
                               'framework.sound.SomManager',
                               'org.flixel.*',
                               'game.core.ILevel',
                               'game.scenes.MainMenu']

    subject.package.should == ''
    subject.package_imported?('framework.sound.SomManager').should be_true
    subject.package_imported?('org.flixel.*').should be_true
    subject.package_imported?('org.flixel.FlxGame').should be_true
    subject.package_imported?('org.flixel.FlxSprite').should be_true
    subject.package_imported?('org.flixel.something.Inexistent').should be_false
  end
end
