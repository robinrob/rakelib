$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rakelib/lib'

require 'colorize'
require 'gitrepo'
require 'gitconfigfile'


namespace :git do
  desc 'Commit changes to git.'
	task :commit, [:msg] => [:clean, :add, :status] do |t, args|
    msg = args[:msg] || "Auto-update."

	  git("commit -m '#{msg}'")
	end
	
	
  desc 'Stage changes in git.'
	task :add do
	  git("add -A")
	end
	

  desc 'Push changes to corresponding branch at origin.'
	task :push do
	  git("push -u origin " + branch())
	end
	

  desc 'Pull changes from corresponding branch at origin.'
	task :pull do
	  git("pull origin " + branch())
	end
	
	
  desc 'Git status.'
	task :status do
	  git("status")
	end


  desc 'Git log with fancy output.'
	task :log do
	  # Git formats
	  git_log_medium_format = "%C(bold)Commit%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B"
	  #git_log_oneline_format = "%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n"
	  #git_log_brief_format = "%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n"
	
	
	  # Git aliases
	  #gl="git log --topo-order --pretty=format${_git_log_medium_format}" + wrap_quotes(git_log_medium_format)
	  gls="git log --topo-order --stat --pretty=format" + wrap_quotes(git_log_medium_format)
	  #gld="git log --topo-order --stat --patch --full-diff --pretty=format" + wrap_quotes(git_log_medium_format)
	  #glo="git log --topo-order --pretty=format" + wrap_quotes(git_log_oneline_format)
	  #glg="git log --topo-order --all --graph --pretty=format" + wrap_quotes(git_log_oneline_format)
	  #glb="git log --topo-order --pretty=format" + wrap_quotes(git_log_brief_format)
	  #glc="git shortlog --summary --numbered"
	
	  system(gls)
	end


	desc 'Deinit a git submodule and remove it from .gitmodules.'
	task :deinit, [:arg1] do |t, args|
	  submodule = args[:arg1]
	
	  puts "Deinit repo: ".red + "#{submodule}".green
	  `rm -rf #{submodule}`
	  `git rm -rf --ignore-unmatch --cached #{submodule}`
	  `git submodule deinit #{submodule} 2> /dev/null`
	
	  file = GitConfigFile.new(:filename => '.gitmodules')
	  file.del_block submodule
	  file.sort!
	  file.save
  end


  desc 'Perform a command for all repositories at and below the current level
  in the tree.'
  task :foreach, [:command, :quiet, :recurse_down] do |t, args|
    command = args[:command]
    quiet = args[:quiet] || false
    recurse_down = args[:recurse_down].nil? ? false : true

    config = { :quiet => quiet, :recurse_down => recurse_down}

    unless command.nil?
      puts "Quiet mode!".light_blue if quiet

      result = GitRepo.new(:name => 'root', :path => './').each_sub(command, config)
    end

    puts "Ran for ".green << "#{result[:counter]}".yellow << " repositories.".green \
	  << " Max nesting: ".green << "#{result[:max_nesting]}".yellow << ".".green
  end


  desc 'Sort .gitmodules file alphabetically by submodule name.'
  task :sort_sub do
    GitConfigFile.new(:filename => '.gitmodules').sort!.save
    puts "Sorted .gitmodules file:".green
    puts `cat .gitmodules`.strip.yellow
  end
end


def wrap_quotes(s)
  "'" + s + "'"
end


def git(command)
  system("git " + command)
end


def branch()
	`git branch | grep '*'`[2...-1]
end
