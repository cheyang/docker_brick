require "thread"  
require "docker"

module Brick
  module Docker
    
  end
end

module Brick
  module Docker
    class DockerClient
      
      to_aliase_methods = [:run]
      
      attr_accessor :base_url, :connection
      
      @@connection_pool = Hash.map
      
      @base_url = ENV['DOCKER_URL']
      
      def self.connection base_url
        
          @connection ||= @@connection_pool[base_url.to_sym]
          
          if(@connection.nil?)
            @connection = Docker::Connection.new(base_url, {}) 
            @@connection_pool[base_url.to_sym] = @connection
          end
          
        
        @connection
      end
      
      def initialize(options)
        
        unless(options[:base_url].nil?)
          @base_url = options[:base_url]
        end
        
        if @base_url.nil?
          @base_url = 'unix:///var/docker.sock'
        end
        
        connection @base_url
      end
      
      def self.default
        DockerClient.new
      end
      
      
      
    end
  end
end