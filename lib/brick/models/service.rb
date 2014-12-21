module Brick
  module Models
    class Service
      attr_accessor :docker_client, :name, :links, :service_config_hash
      
      def initialize(name, config)
        @name = name
        @service_config_hash = config
      end
      
    end
  end  
end
