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
           config_file = options[:config_file]
         end
        
         init_services_from_config(config_file)
         
         @docker_client = client
        
      end
      
      
      def get_services(service_name, inlcude_links=false) 
        
      end
      
      def init_services_from_config(config_file=nil)
        config_hash = load_yaml_file config_file
        
        config = config_hash.to_ostruct
        
        @services = []
        
        config_hash.each_key{|key|  
          @services << Service.new(key,eval("config.#{key}"))  
           #@services << Service.new(key,config_hash[key])        
        }
        
        
        
      end
      
    end
  end  
end
