require 'brick/mixin/yaml_helper'
require 'brick/docker/docker_client'
#require 'deepstruct'

module Brick
  module Models
    class Project
      
      include Brick::Mixin::YamlHelper
      
      attr_accessor :services, :docker_client, :name, :recreate, :insecure_registry
      
      def initialize(project_name ,options={},client=nil)
        
         @name = project_name
        
         unless options[:config_file].nil?
           @config_file = options[:config_file]
         end
         
         @docker_client = client ? client : Brick::Docker::DockerClient::default
        
         init_services_from_config(@config_file)
                 
      end
      
      
      def get_services(service_name, inlcude_links=false) 
        
      end
      
      def get_service(name)
        
        service = nil
        
        unless @services.nil?
        
          service = @services[name]
           
       end
       
       service
      end
      
      #initialize the configuration of each service, and put it into services
      def init_services_from_config(config_file=nil)
        config_hash = load_yaml_file config_file
        
       # config = config_hash.to_ostruct
        
        @services = {}
        
        config_hash.each_key{|key|  
        #  @services << Service.new(key,eval("config.#{key}"))  
           @services[key] =Service.new("#{@name}_#{key}_1",config_hash[key],@docker_client)        
        }
        
        @services.each_key{|key|  
            service = @services[key]
            service.update_links @services
            service.update_volumes_from @services
            service.update_image_for_building_tag("#{self.name}_#{key}")
        }
        
      end
      
      
      def up(detach_mode = true, enable_link=true, recreate=false)
          
          self.services.each_key{|key| service= services[key]
          
              if service.container_exist?
                puts "Recreating #{service.name} ..."
              else
                puts "Creating #{service.name} ..."
              end
          
              if service.can_be_built?
                unless service.image_exist?
                  # by default, not set cache
                  service.build nil, true, ::Brick::Config[:project_dir]
                end
              end
             
              service.run enable_link, recreate
              
              unless detach_mode
                service.attach
              else
                puts "Service #{service.name} has been started"
              end
          }
          
          
      end
      
      
      #create the service according to the service name
      def run_services(service_name, enable_link=true)
        
        service = @services[service_name]  
        
        to_build = false
        
         if service.can_be_built?
           
           if service.image_exist? 
             if ::Brick::Config[:rebuild]
                to_build=true
              else
                puts "The image #{service.image_name} already exists!"
             end
           else
             to_build = true
           end
           
         end
         
         if to_build
           service.build nil, true, ::Brick::Config[:project_dir]
         end
        
        raise ServicesNotFoundException.new("service #{service_name} is not found in #{@config_file}") if service.nil?
        service.run enable_link
        
      end
      
      def build_services no_cache=false, project_dir=nil
        self.services.each_key{|key| service= services[key]
          
          
          if service.can_be_built?
            service.build("#{self.name}_#{key}",no_cache,project_dir)
          else
            ::Brick::CLI::logger.info("uses an image, skipping #{key}")
          end
          
        }
      end
      
    end
  end  
end
