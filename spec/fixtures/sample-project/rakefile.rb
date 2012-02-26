require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'rake/clean'
require 'flashsdk'
require 'asunit4'

##
# Set USE_FCSH to true in order to use FCSH for all compile tasks.
#
# You can also set this value by calling the :fcsh task 
# manually like:
#
#   rake fcsh run
#
# These values can also be sent from the command line like:
#
#   rake run FCSH_PKG_NAME=flex3
#
# ENV['USE_FCSH']         = true
# ENV['FCSH_PKG_NAME']    = 'flex4'
# ENV['FCSH_PKG_VERSION'] = '1.0.14.pre'
# ENV['FCSH_PORT']        = 12321

##############################
# Debug

# Compile the debug swf
mxmlc "bin/globalgamejam2012-debug.swf" do |t|
  t.input = "src/Main.as"
  t.debug = true
	t.as3 = true
	t.class_name = "Main"
	t.default_size = "960 640"
	t.source_path << "src"
	t.library_path << "lib/greensock.swc"
	t.library_path << "lib/AnimationPack.swc"
	t.optimize = ""
	t.omit_traces = ""
	t.show_action_script_warnings = ""
	t.show_binding_warnings = ""
	t.show_invalid_c_s_s = ""
	t.show_deprecation_warnings = ""
	t.show_unused_type_selector_warnings = ""
	t.strict = ""
	t.use_network = ""
	t.use_resource_bundle_metadata = ""
	t.warnings = ""
	t.static_link_r_s_l = ""
end

desc "Compile and run the debug swf"
flashplayer :run => "bin/globalgamejam2012-debug.swf"

##############################
# Test

library :asunit4

# Compile the test swf
mxmlc "bin/globalgamejam2012-test.swf" => :asunit4 do |t|
  t.input = "src/test_runner.swf.as"
  t.source_path << 'test'
  t.debug = true
end

desc "Compile and run the test swf"
flashplayer :test => "bin/globalgamejam2012-test.swf"

##############################
# SWC

compc "bin/Main.swc" do |t|
  t.input_class = "Main"
  t.source_path << 'src'
end

desc "Compile the SWC file"
task :swc => 'bin/Main.swc'

##############################
# DOC

desc "Generate documentation at doc/"
asdoc 'doc' do |t|
  t.doc_sources << "src"
  t.exclude_sources << "src/test_runner.swf.as"
end

##############################
# DEFAULT
task :default => :run

