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
      
      def create config_hash, name=nil
        
       docker_hash= transform_docker_hash(config_hash)
        
       docker_hash['name'] = name unless name.nil?
        
        begin
          container = ::Docker::Container.create(docker_hash, connection)
        rescue ::Docker::Error::NotFoundError => exception
            if exception.message.include? 'No such image'
              ::Docker::Image.create({'fromImage'=> config_hash['image']},{}, connection)
               container = ::Docker::Container.create(docker_hash, connection)
            else
              raise exception
          end
          return container
        end
      end
      
      #if the container is already existed, reuse it
      #if the container is not started, start it
      def run config_hash, name=nil
        
        container = get_container name
        
        
        if container.nil?
          container = create config_hash, name
        else
          Brick::CLI::logger.info "container #{name} has already existed."
        end
        
        Brick::CLI::logger.info "container #{container}."
        
        if container.info["Status"].include? "Exited"
          container.start
        else
          Brick::CLI::logger.info "container #{name} is #{container.info["Status"]}"
        end
      end
      
      def get_container  name=nil
        
        container = nil
        
        unless name.nil?
          container = ::Docker::Container.search_by_name name, connection
        end
        
        container.first
        
      end
      
    end
  end
end