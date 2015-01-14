require 'brick/cli'

class Brick::CLI::ServiceNew < Brick::CLI
  banner 'brick service new PROJECT(options)'
  
   option :links, 
    :long  => "--links service1,service2",
    :default => nil,
    :description => "Link to containers in another service"
    
    option :build, 
    :long  => "--build centos",
    :default => nil,
    :description => "the service is built with Dockerfile from specified linux platform like redhat,centos,ubuntu"
    
    option :image, 
    :long  => "--image redis",
    :default => nil,
    :description => "the service is from image"

  def run
    
  end
end