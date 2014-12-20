require 'brick/mixin/yaml_helper'
require 'deepstruct'

module Brick
  module Models
    class Project
      
      include Brick::Mixin::YamlHelper
      
      attr_accessor :services, :docker_client, :name, :recreate, :insecure_registry
      
      def initialize(options={})
        
         unless options[:config_file].nil?
           config_file = options[:config_file]
         end
        
         init_services_from_config(config_file)
        
      end
      
      
      def get_services(service_name, inlcude_links=false) 
        
      end
      
      def init_services_from_config(config_file=nil)
        config_hash = load_yaml_file config_file
        
        config = DeepStruct.wrap(config_hash)
        
        @services = []
        
        config_hash.each_key{|key|  
          @services << Service.new(key,eval("config.#{key}"))        
        }
        
        
        
      end
      
    end
  end  
end
