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
        
      conn = nil
        
        @@lock.synchronize do
          conn ||= @@connection_pool[base_url.to_sym]
          
          if(conn.nil?)
            conn = ::Docker::Connection.new(base_url, {}) 
            @@connection_pool[base_url.to_sym] = @connection
          end
        end 
        
        conn
      end
      
      def initialize(options={})
        
        unless(options[:base_url].nil?)
          @base_url = options[:base_url]
        end
        
        
          @base_url ||= 'unix:///var/run/docker.sock'
        
        
        @connection= self.class.connection @base_url
        
        puts "#{__method__} #{__LINE__} @connection=#{@connection}"
      end
      
      def self.default
        @@default_client ||= DockerClient.new
        #puts "client=#{@@default_client}"       
        return @@default_client
      end
      
      def create config_hash
        begin
          container = ::Docker::Container.create(transform_docker_hash(config_hash), connection)
        rescue ::Docker::Error::NotFoundError => exception
            if exception.message.include? 'No such image'
              ::Docker::Image.create({'fromImage'=> config_hash['image']},{}, connection)
               container = ::Docker::Container.create(transform_docker_hash(config_hash), connection)
            else
              raise exception
          end
          return container
        end
      end
      
    end
  end
end