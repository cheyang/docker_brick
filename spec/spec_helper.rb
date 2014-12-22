$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'

require 'brick'

require 'ostruct'


Docker.logger=Logger.new(STDOUT)


RSpec.shared_context "local paths" do
  def project_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end

