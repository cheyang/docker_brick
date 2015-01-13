cd /docker_brick
git pull
gem build docker_brick.gemspec
gem install brick-0.0.1.gem
cd /
rm -rf /myapp
cp -r /docker_brick/spec/projects/rails/myapp/ /
