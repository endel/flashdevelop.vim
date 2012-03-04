require File.expand_path('spec/spec_helper')

describe FlashDevelop::Project do
  context "converting as3proj to sprouts" do
    subject { FlashDevelop::Project.new }

    it 'should get mxmlc options' do
      options = subject.parse_as3proj("spec/fixtures/sample-project/rufus.as3proj")
      options.should be_an_instance_of(Hash)

      options['class_name'].should == 'Main'
    end

    it 'should generate sprout files' do
      options = subject.parse_as3proj("spec/fixtures/sample-project/rufus.as3proj")
      options.should be_an_instance_of(Hash)

      subject.build_options = options
      subject.class_name.should == 'Main'
      subject.bin_path.should == 'bin'
      subject.src_path.should == 'src'
      subject.doc_path.should == 'doc'
      subject.generate_sprout_files!("spec/fixtures/sample-project")
    end
  end
end
