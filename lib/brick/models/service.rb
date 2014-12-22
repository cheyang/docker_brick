module Brick
  module Models
    class Service
      attr_accessor :client, :name, :links, :service_config_hash
      
      def initialize(name, config, client)
        @name = name
        @service_config_hash = config
        @client = client
      end
      
      def create_or_start
        
      end
      
    end
  end  
end
