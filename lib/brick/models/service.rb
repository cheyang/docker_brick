require 'brick/mixin'

module Brick
  module Models
    class Service
      
      attr_accessor :client, :name, :links, :service_config_hash, :container, :volumes_from
      
      def initialize(name, config, client)
        self.name = name
        self.service_config_hash = config
        self.client = client
        #puts "client=#{client}"
        unless config["links"].nil?         
          if  config["links"].instance_of?(String)
            self.links= [config["links"]]
          else
            self.links= config["links"].dup
          end
        end
        
        unless config["volumes_from"].nil?
         if  config["volumes_from"].instance_of?(String)
            self.volumes_from= [config["volumes_from"]]
          else
            self.volumes_from= config["volumes_from"].dup
          end
        end
        
      end
      
      def update_volumes_from services
        
        new_volumes_from_config = []
        
        new_volumes_from = []
        
        unless volumes_from.nil?
          
          volumes_from.each {|vo|
                           #new_volumes_from << services[vo]
                            vo_parts = vo.split(':')
                            
                            #only one part
                            if vo_parts.size == 1
                              new_vo = "#{services[vo_parts[0]].name}:rw"
                            else
                              new_vo=  "#{services[vo_parts[0]].name}:#{vo_parts[1]}"
                            end
                            
                            new_volumes_from<< services[vo_parts[0]]
                            
                            new_volumes_from_config << new_vo
                            
                            }
          self.volumes_from = new_volumes_from
          
          service_config_hash["volumes_from"] = new_volumes_from_config
        end
      end
      
      
      def update_links services
        
        new_links_config = []
        
        new_links =[]
        
         unless links.nil?
           links.each{|link|
                
                link_array=link.split(':')
                
                #It's for getting the real service name
                service_key = link_array[0]
                
                alias_name = link_array[-1]
                
                service_container= services[service_key]
                
                new_links << service_container
                
                new_links_config << "#{service_container.name}:#{alias_name}"
           }
           
         self.links=new_links
         
         service_config_hash["links"] = new_links_config
         end
        
         
      end
      
      #equals to "docker run"
      def run enable_link=true
        
        if running?
          Brick::CLI::logger.debug "the service #{Name} is already running. exited."
          return
        end
        
        unless volumes_from.nil?
          volumes_from.each{|vo| vo.run enable_link}
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
      def running?
        is_running = false
        unless container.nil?
          is_running = container.is_running?
        end
        is_running
      end
      
     
      
    end
  end  
end
