require 'monitor'
require "docker"

module Brick
  module Docker
    
  end
end

module Brick
  module Docker
    class DockerClient
      include Brick::Mixin::DockerSupport
      
      @@default_client = nil
      
      @@lock = Monitor.new
      
      to_aliase_methods = [:run]
      
      attr_accessor :base_url, :connection
      
      @@connection_pool = Hash.new
      
      @base_url = ENV['DOCKER_URL']
      
      def self.connection base_url
        
        @@lock.synchronize do
          @connection ||= @@connection_pool[base_url.to_sym]
          
          if(@connection.nil?)
            @connection = ::Docker::Connection.new(base_url, {}) 
            @@connection_pool[base_url.to_sym] = @connection
          end
        end 
        
        @connection
      end
      
      def initialize(options={})
        
        unless(options[:base_url].nil?)
          @base_url = options[:base_url]
        end
        
        
          @base_url ||= 'unix:///var/docker.sock'
        
        
        self.class.connection @base_url
      end
      
      def self.default
        @@default_client ||= DockerClient.new
        #puts "client=#{@@default_client}"       
        return @@default_client
      end
      
      def create config_hash
        container = ::Docker::Container.create(transform_docker_hash(config_hash), connection)        
      end
      
    end
  end
end