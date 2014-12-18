require 'yaml'

module Brick
  module Models
    class Project
      
      include YamlHelper
      
      attr_accessor :services, :docker_client, :name, :recreate, :insecure_registry
      
      def initialize(options={})
        
         unless options[:config_file].nil?
           config_file = options[:config_file]
         end
        
         @config = YAML::load_file config_file
        
      end
      
      
      def get_services(service_name, inlcude_links=false)
        
      end
      
      def get_all_services()
        
      end
      
    end
  end  
end
