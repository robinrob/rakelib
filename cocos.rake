$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'

require 'colorize'


namespace :cocos do
  desc 'Run the project in the default browser.'
	task :run do
	  system("cocos run -p web -b '#{ENV['BROWSER']}'")
	end
end
