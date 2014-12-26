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
        unless config["links"].nil?         
          if  config["links"].instance_of?(String)
            @links = [config["links"]]
          else
            @links = config["links"]
          end
        end
      end
      
      def update_links services
        new_links = []
        
        links.each{|link|
            if link.instance_of?(String)
              new_links << services[link]
            end
        
        }
        
        
        
      end
      
      def run enable_link=true
        
        if enable_link
          
        end
        
        
        client.run @service_config_hash, name
      end
      
    end
  end  
end
