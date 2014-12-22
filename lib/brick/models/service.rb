require 'brick/mixin'

module Brick
  module Models
    class Service
      include Brick::Mixin::DockerSupport
      
      attr_accessor :client, :name, :links, :service_config_hash
      
      def initialize(name, config, client)
        @name = name
        @service_config_hash = config
        @client = client
      end
      
      def create_or_start
        client.create @service_config_hash
      end
      
    end
  end  
end
