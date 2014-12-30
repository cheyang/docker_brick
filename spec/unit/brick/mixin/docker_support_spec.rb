require 'spec_helper'
include Brick::Mixin::YamlHelper
include Brick::Mixin::DockerSupport

describe Brick::Mixin::DockerSupport do
  
  before :all do
    @config_hash = load_yaml_file File.join(File.dirname(__FILE__),'docker_support.yml' )
  end
  
  describe '#common_config' do
    
    
    
    it 'environment variable array tranformation' do
      expect((transform_docker_hash @config_hash['env_array'])["Env"]).to eq ["ABC=development","CYCY=TEST"]
    end
    
    it 'environment variable hash tranformation' do 
      expect((transform_docker_hash @config_hash['env_hash'])["Env"]).to eq ["ABC=test","CDE=cycy"]
    end
    
    it 'command tranformation' do 
      expect((transform_docker_hash @config_hash['command_test'])["Cmd"]).to eq ["/bin/bash","-c","while true; do env; sleep 1; done"]
    end
    
  end
  
  
  describe '#create_config' do
    #create_config_hash = create_config @config_hash
     it 'port configruation for creating container' do 
      expect((create_config @config_hash['port_test'])["ExposedPorts"]).to eq({"5432/tcp"=>{}, "22/tcp"=>{}})
    end
    
     it 'port attribute should be removed creating container' do 
      expect((create_config @config_hash['port_test'])["Ports"]).to eq nil
    end
    
    it 'volume configruation for creating container' do 
      expect((create_config @config_hash['volume_test'])["Volumes"]).to eq({"/root/hello_docker"=>{}, "/test.rb"=>{}, "/test"=>{}})
    end
    
    
  end
  
  describe '#start_config' do
    #create_config_hash = start_config @config_hash
      it 'port configruation for starting container' do 
      expect((start_config @config_hash['port_test'])["PortBindings"]).to eq({"5432/tcp"=>[{ "HostPort"=> "5432" }], "22/tcp"=>[{ "HostPort"=> "3001" }]})
    end
    
     it 'port attribute should be removed starting container' do 
      expect((start_config @config_hash['port_test'])["Ports"]).to eq nil
    end
    
    it 'volume configruation for starting container' do 
      expect((start_config @config_hash['volume_test'])["Binds"]).to eq(["/root/hello_docker:/root/hello_docker:wr","/root/test.rb:/test.rb:ro","/nc_server:/test:wr"])
    end
    
     it 'volume attribute should be removed starting container' do 
      expect((start_config @config_hash['volume_test'])["Volumes"]).to eq nil
    end
  end
  
end