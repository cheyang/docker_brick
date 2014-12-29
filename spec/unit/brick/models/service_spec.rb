require 'spec_helper'
include Brick::Mixin::YamlHelper

describe Brick::Models::Service do
  
  before :all do
    @client = Brick::Docker::DockerClient::default
   
  end
  
  describe 'test data volumes' do
   
     config_hash = load_yaml_file File.join(File.dirname(__FILE__),'fig_volumes.yml' )
     
     subject(:fig_volumes) { described_class.new("test_volume", config_hash["test_volume"],@client ) }
      
     it 'if it has volumes config' do
        fig_volumes.run
     end
  end
  
end

