require 'spec_helper'


describe Brick::Models::Project do
  
   before :all do
     @config_file = File.join(File.dirname(__FILE__),'fig_single.yml' )
   end
   
   subject(:fig_single) { described_class.new("bdt",{:config_file=>@config_file}) }
   
   describe '#initialize' do
     
     context "when parsing fig_completed.yml" do
       it "parse redis service" do
       #service nginx
       redis = OpenStruct.new
       
       redis.images = "redis:latest"
       
        #subject.services.each{|service|puts "links=#{service.service_config_hash["links"]}"; puts service.service_config_hash}
       
       expect(fig_single.services["redis"].name).to eq 'bdt_redis_1'
       
       
      end
    end     
  end
  
  describe "#create a single service from image" do
     context "no link support" do
       
       context "the redis container doesn't exist" do
         it "create redis service" do
            instance=fig_single.run_services 'redis'
            
            puts instance
          end
      end
      
      context "the redis container already exist" do
         it "create web service" do
            instance=fig_single.run_services 'redis'
            
            puts instance
          end
       end
     end
 end
 
 subject(:fig_dependency) { described_class.new("bdt",{:config_file=>File.join(File.dirname(__FILE__),'fig_dependency.yml' )}) }
 
 describe "#create a service which has dependency" do
     context "no link support" do
       
       context "disable dependency" do
         it "create redis service" do
            instance=fig_dependency.run_services 'web', false
            
            puts instance
          end
      end
      
      context "enable dependency" do
         it "create redis service" do
            instance=fig_dependency.run_services 'web', true
            
            puts instance
          end
       end
     end
 end
 
end