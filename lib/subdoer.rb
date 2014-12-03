class SubDoer

  Indentation = "            |"
  Me = 'robinrob'


  attr_accessor :counter, :max_nesting


  def initialize()
    @depth = 0
    @max_nesting = @depth
    @counter = 0
  end


  def each_sub(repo, command, config={})
    @counter += 1
    parent_dir = Dir.pwd
    Dir.chdir("#{repo.path}")

    nest
    if config[:recurse_down]
      do_repo(repo, command, config)
    end

    if (config[:not_recursive] == nil) && (repo.submodules.length > 0)
      puts "#{indent}Recursing into #{repo.path} ...".light_cyan

      repo.submodules.each do |submodule|
        each_sub(submodule, command, config)
      end
    end

    unless config[:recurse_down]
      do_repo(repo, command, config)
    end
    denest_to(parent_dir)
  end


  private
  def do_repo(repo, command, config)
    puts "#{arrow} #{entering_repo(repo.path)}"

    if repo.owner == Me
      if config[:quiet]
        `#{command}`
      else
        system("#{command}")
      end

    else
      puts "#{indent.cyan}#{repo_owner(repo.owner, repo.path)} #{not_me}'"
    end
  end


  def arrow
    "#{indent}".cyan << "[".green << "#{nesting}".cyan << "]>".green
  end


  def repo_owner(owner, repo)
    "Owner ".red << "#{owner.yellow}" << " of repo ".red << "#{repo}".yellow
  end


  def not_me
    "not #{Me}!".red
  end


  def entering_repo(repo)
    "Entering repo: ".green << "#{repo}".cyan
  end


  def indent
    Indentation * nesting
  end


  def nesting
    @depth - 1
  end


  def nest
    @depth += 1
    if nesting > @max_nesting then @max_nesting = nesting end
  end


  def denest_to(parent_dir)
    @depth -= 1
    Dir.chdir(parent_dir)
  end

end