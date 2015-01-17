$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'

require 'colorize'


namespace :cocos do

  desc 'Run the project in the default browser.'
	task :run, [:where] do |t, args|
  where = args[:where] || 'web'
	  system("cocos run -p #{where} -b 'Google\ Chrome'")
	end

end
