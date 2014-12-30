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
    
    
  end
  
  describe '#start_config' do
    
  end
  
end