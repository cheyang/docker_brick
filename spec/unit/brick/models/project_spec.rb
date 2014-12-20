require 'spec_helper'


describe Brick::Models::Service do
   subject { described_class.new({:config_file=>File.join(project_dir,'fig_complete.yml')}) }
   
   describe '#initialize' do
     subject.services.each{|x| puts x}
   end
end