require File.expand_path('spec/spec_helper')

describe FlashDevelop::Project do
  context "converting as3proj to sprouts" do
    subject { FlashDevelop::Project.new }

    it 'should identify project type' do
      type = subject.identify_project_type("spec/fixtures/sample-project/")
      type.should be_a_kind_of Hash

    end

    it 'should generate sprout files' do
    end

  end
end
