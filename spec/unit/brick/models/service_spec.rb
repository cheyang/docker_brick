require 'spec_helper'
include Brick::Mixin::YamlHelper

describe Brick::Models::Service do
  
  before :all do
    `docker stop $(docker ps -aq)`
     `docker rm $(docker ps -aq)`    
    @client = Brick::Docker::DockerClient::default
   `mkdir -p /hello_docker`
   `echo hello > /tmp/test.rb`
  end
  
  describe 'test data volumes' do
   
     config_hash = load_yaml_file File.join(File.dirname(__FILE__),'fig_volumes.yml' )
     
     subject(:fig_volumes) { described_class.new("test_volume", config_hash["test_volume"],@client ) }
      
     it 'if it has volumes config' do
        fig_volumes.run
        
        expect(fig_volumes.container_info["Volumes"]).to eq({"/root/hello_docker"=>"/root/hello_docker", "/test"=>"/nc_server", "/test.rb"=>"/root/test.rb"})
     end
  end
  
   describe 'test data volumes' do
     config_hash = load_yaml_file File.join(File.dirname(__FILE__),'fig_volumes_from.yml' )
     
     subject(:data_container) { described_class.new("data_container", config_hash["data_container"],@client ) }
     
     subject(:app_container) { described_class.new("app_container", config_hash["app_container"],@client ) }
      
     it 'app_container volumes from data_container' do
       app_container.update_volumes_from({"data_container" => data_container})
       app_container.run
       
       expect(app_container.running?).to eq true
       expect(data_container.running?).to eq true
       
       expect(app_container.container_info["Volumes"]).to eq({"/hello_docker"=> "/hello_docker",
        "/test"=> "/tmp",
        "/test.rb"=> "/tmp/test.rb"
        })
        
        expect(app_container.container_info["HostConfig"]["VolumesFrom"]).to eq(["data_container:rw"])
     end
   end
  
  
  describe 'test interactive container' do
     config_hash = load_yaml_file File.join(File.dirname(__FILE__),'fig_volumes_from.yml' )
     config_hash.merge!({"tty"=>true, "open_stdin"=>true})
     
     subject(:interactive_container) { described_class.new("interactive_container", config_hash["interactive_container"],@client ) }
     it 'interactive container' do
          interactive_container.run
          
          interactive_container.attach
     end
  end
end

