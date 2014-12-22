require 'brick/mixin/yaml_helper'
require 'brick/docker/docker_client'
#require 'deepstruct'

module Brick
  module Models
    class Project
      
      include Brick::Mixin::YamlHelper
      
      attr_accessor :services, :docker_client, :name, :recreate, :insecure_registry
      
      def initialize(options={},client=Brick::Docker::DockerClient::default)
        
         unless options[:config_file].nil?
           @config_file = options[:config_file]
         end
         
        
         init_services_from_config(@config_file)
         
         @docker_client = client
        
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
           @services[key] =Service.new(key,config_hash[key],@docker_client)        
        }
        
        
        
      end
      
      
      def up(include_link=true,restart=true)
        
      end
      
      #create the service according to the service name
      def create_services(service_name)
        
        service = @services[service_name]               
        raise ServicesNotFoundException.new("service #{service_name} is not found in {@config_file}") if service.nil?
        service.create_or_start
        
      end
      
    end
  end  
end
