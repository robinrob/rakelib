$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'


namespace :jekyll do

  desc 'Start Jekyll server.'
	task :server => 'jekyll:kill' do
	  system("jekyll serve --watch --detach")
	end


  desc 'Kill Jekyll server.'
  task :kill do
   system("killp jekyll")
  end

end
