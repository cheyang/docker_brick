require 'spec_helper'


describe Brick::Models::Project do
  
   before :all do
     @config_file = File.join("bdt",File.dirname(__FILE__),'fig_single.yml' )
   end
   
   subject { described_class.new({:config_file=>@config_file}) }
   
   describe '#initialize' do
     
     context "when parsing fig_completed.yml" do
       it "parse nginx service" do
       #service nginx
       nginx = OpenStruct.new
       
       nginx.images = "nginx:latest"
       
        #subject.services.each{|service|puts "links=#{service.service_config_hash["links"]}"; puts service.service_config_hash}
       
       expect(subject.services["redis"].name).to eq 'bdt_redis_1'
       
       
      end
    end     
  end
  
  describe "#create a single service from image" do
     context "no link support" do
       
       context "the redis container doesn't exist" do
         it "create redis service" do
            instance=subject.run_services 'redis'
            
            puts instance
          end
      end
      
      context "the redis container already exist" do
         it "create redis service" do
            instance=subject.run_services 'redis'
            
            puts instance
          end
       end
     end
 end
 
 subject { described_class.new("bdt",{:config_file=>File.join(File.dirname(__FILE__),'fig_dependency.yml' )}) }
 
 describe "#create a service which has dependency" do
     context "no link support" do
       
       context "disable dependency" do
         it "create redis service" do
            instance=subject.run_services 'redis'
            
            puts instance
          end
      end
      
      context "enable dependency" do
         it "create redis service" do
            instance=subject.run_services 'redis'
            
            puts instance
          end
       end
     end
 end
 
end