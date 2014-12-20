require 'spec_helper'


describe Brick::Models::Project do
  
   before :all do
     @config_file = File.join(File.dirname(__FILE__),'fig_completed.yml' )
   end
   
   subject { described_class.new({:config_file=>@config_file}) }
   
   describe '#initialize' do
     
     context "when parsing fig_completed.yml" do
       it "parse nginx service" do
       #service nginx
       nginx = OpenStruct.new
       
       nginx.images = "nginx:latest"
       
       puts subject.services[0].service_config.links
       
       subject.services[0].name.should eq 'nginx'
       
       
     end
     end
     
     
   end
end