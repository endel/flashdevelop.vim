require File.expand_path('spec/spec_helper')

describe FlashDevelop::Support::Parser do
  context "converting as3proj to sprouts" do
    subject { FlashDevelop::Support::Parser }

    it 'should identify project type' do
      project = FlashDevelop::Project.new
      type = project.identify_project_type("spec/fixtures/sample-project/")
      type.should be_a_kind_of Hash
      type[:parser].should be_an_instance_of(FlashDevelop::Support::Parser::FD)

      data = type[:parser].parse("spec/fixtures/sample-project/rufus.as3proj")
      data.should be_a_kind_of Hash
      data.should == {
        :debug_swf_name => "globalgamejam2012-debug.swf",
        :test_swf_name => "globalgamejam2012-test.swf",
        :build_options =>{
          "as3"=>true,
          "class_name"=>"Main",
          "default_size"=>"960 640",
          "source_path"=>[],
          "accessible"=>false,
          "allow_source_path_overlap"=>false,
          "benchmark"=>false,
          "es"=>false,
          "optimize"=>true,
          "omit_traces"=>true,
          "show_action_script_warnings"=>true,
          "show_binding_warnings"=>true,
          "show_invalid_c_s_s"=>true,
          "show_deprecation_warnings"=>true,
          "show_unused_type_selector_warnings"=>true,
          "strict"=>true,
          "use_network"=>true,
          "use_resource_bundle_metadata"=>true,
          "warnings"=>true,
          "verbose_stack_traces"=>false,
          "static_link_r_s_l"=>true
        }
      }
    end

  end
end
