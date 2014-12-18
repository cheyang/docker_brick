module Brick
  module Models
    class Service
      attr_accessor :docker_client, :name, :links, :service_config
      
      def initialize(config)
        @service_config = config
      end
      
    end
  end  
end
