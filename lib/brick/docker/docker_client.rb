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
        
       docker_hash= create_config(config_hash)
        
       docker_hash['name'] = name unless name.nil?
        
        begin
          container = ::Docker::Container.create(docker_hash, connection)
          #get full information of the container
          container = ::Docker::Container.get(container.id,connection)
        rescue ::Docker::Error::NotFoundError => exception
            if exception.message.include? 'No such image'
              ::Docker::Image.create({'fromImage'=> config_hash['image']},{}, connection)
               container = ::Docker::Container.create(docker_hash, connection)
               #get full information of the container
               container = ::Docker::Container.get(container.id,connection)
            else
              raise exception
          end
          return container
        end
      end
      
      #if the container is already existed, reuse it
      #if the container is not started, start it
      def run config_hash, name=nil
        #byebug        
        container = get_container_by_name name
        
        
        if container.nil?
          container = create config_hash, name
        else
          Brick::CLI::logger.info "container #{name} has already existed."
        end
        
        Brick::CLI::logger.debug "container #{container}."
        
        
        unless container.is_running?
          container.start(start_config(config_hash))
        else
          Brick::CLI::logger.info "container #{name} is #{container.info["Status"]}"
        end
        
        container
      end
      
      def get_container_by_name  name=nil
        
        container = nil
        
        unless name.nil?
          container = ::Docker::Container.search_by_name name, connection
        end
        
        container.first
        
      end
      
      def get_container_by_id id
        ::Docker::Container.get(id,connection)
      end
      
      
      def build_from_dir options={}
        
        image_name = options[:image_name]
        
        dockerfile_path = options[:build_dir]
        
        project_dir = options[:project_dir]
        
        no_cache = options[:no_cache]
        
        dockerfile_path = determine_dockerfile_path(dockerfile_path, project_dir)
        
        image = Docker::Image.build_from_dir(dockerfile_path, {"t"=>image_name, "nocache" =>no_cache }) 
        
        #{ |chunk| puts chunk }
        
        image
      end
      
    end
  end
end
