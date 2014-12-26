require 'brick/mixin'

module Brick
  module Models
    class Service
      
      attr_accessor :client, :name, :links, :service_config_hash, :container
      
      def initialize(name, config, client)
        @name = name
        @service_config_hash = config
        @client = client
        #puts "client=#{client}"
        unless config["links"].nil?         
          if  config["links"].instance_of?(String)
            links= [config["links"]]
          else
            links= config["links"]
          end
        end
      end
      
      def update_links services
        new_links = []
        
        unless links.nil?
          links.each{|link|
            if link.instance_of?(String)
              new_links << services[link]
            end
            
          }
        end
        
      end
      
      #equals to "docker run"
      def run enable_link=true
        
        if running
          Brick::CLI::logger.debug "the service #{Name} is already running. exited."
          return
        end
        
        if enable_link and !links.nil?
          links.each{|linked_service|
            linked_service.run enable_link
          }
        end
        
        if container.nil?       
          @container = client.run @service_config_hash, name        
        else
          container.start
        end
      end
      
      #Check if the container is running
      def running
        is_running = false
        unless container.nil?
          is_running = container.is_running?
        end
        is_running
      end
      
    end
  end  
end
