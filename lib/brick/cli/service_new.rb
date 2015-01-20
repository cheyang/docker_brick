require 'brick/cli'
require 'byebug'
class Brick::CLI::ServiceNew < Brick::CLI
  banner "brick service new PROJECT(options) --build centos --links db,redis or \
          brick service new PROJECT(options) --image centos --links db,redis"
  
   option :links, 
    :long  => "--links service1,service2",
    :default => nil,
    :description => "Link to containers in another service. It's optional"
    
    option :build, 
    :long  => "--build centos",
    :default => nil,
    :description => "the service is from built with Dockerfile from specified linux platform like redhat,centos,ubuntu. not along with image."
    
    option :image, 
    :long  => "--image redis",
    :default => nil,
    :description => "the service is from image. Not laong with build"

  def run
    
    if ::Brick::Config[:build].nil? and ::Brick::Config[:image].nil?
      show_usage
      puts ("You must specify the way of creating service, either from build or image".colorize(:red))
      exit 1
    end
    
    unless !::Brick::Config[:build].nil? and !::Brick::Config[:image].nil?
       show_usage
       puts ("You must specify the way of creating service, either from build or image. You can't choose both".colorize(:red))
      exit 1
    end
    
    puts "hello #{banner}"
    
     working_dir = Dir.pwd
    
    value=Brick::Generators::NewProjectGenerator.start([working_dir, nil])
    byebug
    puts "value=#{value}"
  end
end