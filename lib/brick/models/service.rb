require 'brick/mixin'
require 'colorize'


module Brick
  module Models
    class Service
      
      include ::Brick::Mixin::Colors
      
      @@waiting_pool = []
      
      attr_accessor :client, :name, :links, :service_config_hash, :container, :volumes_from, :image, :image_name
      
      def self.wait_for_deamon
        @@waiting_pool.each{|thr|
            thr.join       
        }
      end
      
      
      def initialize(name, config, client)
        self.name = name
        self.service_config_hash = config
        self.client = client
        #puts "client=#{client}"
        
        determine_color
        
        unless config["links"].nil?         
          if  config["links"].instance_of?(String)
            self.links= [config["links"]]
          else
            self.links= config["links"].dup
          end
        end
        
        unless config["volumes_from"].nil?
          if  config["volumes_from"].instance_of?(String)
            self.volumes_from= [config["volumes_from"]]
          else
            self.volumes_from= config["volumes_from"].dup
          end
        end
        
        begin
          self.container = ::Docker::Container.get(name)
        rescue 
          self.container = nil
        end
        
      end
      
      def update_volumes_from services
        
        new_volumes_from_config = []
        
        new_volumes_from = []
        
        unless volumes_from.nil?
          
          volumes_from.each {|vo|
            #new_volumes_from << services[vo]
            vo_parts = vo.split(':')
            
            #only one part
            if vo_parts.size == 1
              new_vo = "#{services[vo_parts[0]].name}:rw"
            else
              new_vo=  "#{services[vo_parts[0]].name}:#{vo_parts[1]}"
            end
            
            new_volumes_from<< services[vo_parts[0]]
            
            new_volumes_from_config << new_vo
            
          }
          self.volumes_from = new_volumes_from
          
          service_config_hash["volumes_from"] = new_volumes_from_config
        end
      end
      
      
      def update_links services
        
        new_links_config = []
        
        new_links =[]
        
        unless links.nil?
          links.each{|link|
            
            link_array=link.split(':')
            
            #It's for getting the real service name
            service_key = link_array[0]
            
            alias_name = link_array[-1]
            
            service_container= services[service_key]
            
            new_links << service_container
            
            new_links_config << "#{service_container.name}:#{alias_name}"
          }
          
          self.links=new_links
          
          service_config_hash["links"] = new_links_config
        end
        
        
      end
      
      def exec cmd_array, options ={}
        if self.container.nil?
          raise "no container #{name} running, so we can't execute "
        end
        
        self.container.exec(cmd_array, options){|stream, chunk| puts "#{color_generator(name)} | #{chunk}".chomp }
        
      end
      
      #equals to "docker run"
      def run enable_link=true, recreate=true, detach_mode=false
        
        if running? and (!recreate or can_be_skipped_this_time?)
          Brick::CLI::logger.debug "the service #{name} is already running. exited."
          unless detach_mode
             attach
          end
          
          return
        end
        
        unless volumes_from.nil?
          volumes_from.each{|vo| vo.run enable_link}
        end
        
        config_hash = @service_config_hash.dup
        
        if enable_link and !links.nil?
          links.each{|linked_service|
            linked_service.run enable_link, recreate, detach_mode
            
            unless detach_mode
                linked_service.attach
            else
                puts "Service #{linked_service.name} has been started"
            end
          }
        end
        
        if !enable_link
          config_hash.delete("links")
        end
        
        if recreate and !container.nil?
          #if recreate is true, it will destory the old container, and create a new one
          if running?
            container.stop
          end
          container.delete(:force => true)
          self.container=nil
          skip_next_time
        end
        
        if container.nil?       
          self.container = client.run config_hash, name        
        else
          container.start
        end
        
        unless detach_mode
             attach
        else
            puts "Service #{name} has been started"
        end
        
      end
      
      #Check if the container is running
      def running?
        is_running = false
        
        if container.nil?
          begin
            self.container = ::Docker::Container.get(name)
          rescue 
            self.container = nil
          end
        end
        
        unless container.nil?
          is_running = container.is_running?
        end
        
        is_running
      end
      
      def container_info
       (client.get_container_by_id(container.id)).info rescue {}
      end
      
      
      def attach
        
        thr=Thread.new{
          puts "Attaching to service #{name}"
          container.attach(:stdin => STDIN, :tty => true){|message| 
            
          if message.length > 0
            puts "#{color_generator(name)} | #{message}".chomp
          end
          
          }
        }
        
        #thr.join
        @@waiting_pool << thr
      end
      
      
      def can_be_built?
        !service_config_hash["build"].nil?
      end
      
      def skip_next_time
        @skip = true
      end
      
      def can_be_skipped_this_time?
        @skip == true
      end
      
      def build name=nil, no_cache=false, project_dir=nil
        
        if name.nil?
          name = self.image_name
        end
        
        puts "Start building #{name}..."
        
        if can_be_built?
          self.image = client.build_from_dir({:image_name => name,
            :no_cache => no_cache,
            :project_dir=>project_dir,
            :build_dir=>service_config_hash["build"]})
        else
          Brick::CLI::logger.debug "no build defintion for #{image_build},skip it"
        end
        self.image
      end
      
      def image_exist? 
        ::Docker::Image.exist?(image_name)
      end
      
      def container_exist?
        ::Docker::Container.exist?(name)
      end
      
      #If it's using build tag, will create an actual image name for it.
      #For example, if project name is test, service name is web, the image name should 
      #be test_web
      def update_image_for_building_tag name
        unless service_config_hash["build"].nil?
          service_config_hash["image"]=name
        end
        
        self.image_name = service_config_hash["image"]
      end
    end
  end  
end
