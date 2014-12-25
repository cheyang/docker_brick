require 'brick/mixin'

module Brick
  module Models
    class Service
      
      attr_accessor :client, :name, :links, :service_config_hash
      
      def initialize(name, config, client)
        @name = name
        @service_config_hash = config
        @client = client
        #puts "client=#{client}"
      end
      
      def run
        client.run @service_config_hash, name
      end
      
    end
  end  
end
