require 'spec_helper'

describe Brick::Models::Service do
  
  before :all do
    @client = Brick::Docker::DockerClient::default
   
  end
  
  describe 'test data volumes' do
   
     config_hash = Brick::Mixin::YamlHelper.load_yaml_file File.join(File.dirname(__FILE__),'fig_volumes.yml' )
     
     subject(:fig_volumes) { described_class.new("test_volume", config_hash["test_volume"],@client ) }
      
     fig_volumes.run
  end
  
end

