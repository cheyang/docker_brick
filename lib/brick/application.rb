require 'fileutils'
require 'mixlib/cli'

module Brick
  class Application
    include ::Mixlib::CLI
    
    option :config_file, 
    :short => "-f FILE",
    :long  => "--file FILE",
    :default => File.join(FileUtils.pwd, 'fig.yml'),
    :description => "The configuration file to deploy the project"
    
    option :project, 
    :short => "-p PROJECT",
    :long  => "--project PROJECT",
    :default => File.basename(FileUtils.pwd),
    :description => "Specify an alternate project name"
    
    option :version,
    :short        => "-v",
    :long         => "--version",
    :description  => "Show brick version",
    :boolean      => true,
    :proc         => lambda {|v| puts "brick: #{::Brick::VERSION}"},
    :exit         => 0
    
    
    def configure_brick
      parse_options
      Brick::Config.merge!(config)
    end
    
  end
end