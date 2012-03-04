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
    subject.imports.should be_empty
    subject.package.should == 'com.adobe.utils'

    VIM::Buffer.load('MD5.as')
    subject.imports.should == ["com.adobe.utils.IntUtil", "flash.utils.ByteArray"]
    subject.package.should == 'com.adobe.crypto'
  end
end

