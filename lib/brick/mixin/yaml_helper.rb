require 'yaml'

module Brick::Mixin
  module YamlHelper
    def load_yaml_file(path, expected_type = Hash)
      raise("Cannot find file `#{path}'") unless File.exists?(path)
      yaml = YAML::load_file(path)
      
      if expected_type && !yaml.is_a?(expected_type)
        raise "Incorrect file format in `#{path}', #{expected_type} expected"
      end
      
      yaml
    rescue SystemCallError => e
      raise  "Cannot load YAML file at `#{path}': #{e}"
    end
  end 
end