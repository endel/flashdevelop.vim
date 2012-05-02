require File.expand_path('spec/spec_helper')

describe FlashDevelop::Support::Parser do
  context "converting as3proj to sprouts" do
    subject { FlashDevelop::Support::Parser }

    it 'should identify project type' do
      project = FlashDevelop::Project.new
      type = project.identify_project_type("spec/fixtures/sample-project/")
      type.should be_an_instance_of(FlashDevelop::Support::Parser::FD)
    end

    it 'should parse valid values' do

    end
  end
end
