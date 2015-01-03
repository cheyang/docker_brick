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
        
          service = @service[name]
           
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
        }
        
      end
      
      
      def up(include_link=true,restart=true)
        
      end
      
      #create the service according to the service name
      def run_services(service_name, enable_link=true)
        
        service = @services[service_name]               
        raise ServicesNotFoundException.new("service #{service_name} is not found in #{@config_file}") if service.nil?
        service.run enable_link
        
      end
      
      def build_services no_cache=false, project_dir=nil
        self.services.each{|key| service= services[key]
          
          
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
