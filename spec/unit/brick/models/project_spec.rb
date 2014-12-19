require 'spec_helper'
require 'brick/models/project'

describe Brick::Models::Service do
   subject { described_class.new({:config_file=>'fig_complete.yml'}) }
   
   describe '#initialize' do
     subject.services.each{|x| puts x}
   end
end