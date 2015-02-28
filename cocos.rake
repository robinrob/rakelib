$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'

require 'colorize'


namespace :cocos do

  desc 'Run the project in the specified or default browser.'
	task :run, [:where] do |t, args|
    where = args[:where] || "Google\ Chrome"
    # system('/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --incognito')
	  system("cocos run -p web -b '#{where}'")
	end

end
