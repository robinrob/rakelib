# GitSubDoer encapsulates logic for recursing through a Git repository tree and performing an action for each
# repository linked via the tree.
#
# Recursion can be performed upwards or downwards.
#
# The action can be described as either a system command (each_exec), or as a code block (each).

class GitSubDoer

  Indentation = "            |"
  Me = 'robinrob'


  attr_accessor :counter, :max_nesting


  def initialize()
    @depth = 0
    @max_nesting = @depth
    @counter = 0
  end


  # Run a system command for each Git repository in the tree
  def each_exec(repo, command, config={})
    @counter += 1
    parent_dir = Dir.pwd

    # Perform the action (downwards recursion)
    nest_to("#{repo.path}")
    if config[:recurse_down]
      do_repo(repo, command, config)
    end

    # The recurse-or-not check
    if (config[:not_recursive] == nil) && (repo.submodules.length > 0)
      puts "#{indent}Recursing into #{repo.path} ...".cyan

      repo.submodules.each do |submodule|
        each_exec(submodule, command, config)
      end
    end

    # Perform the action (upwards recursion)
    unless config[:recurse_down]
      do_repo(repo, command, config)
    end
    denest_to(parent_dir)
  end


  # Run (yield) a passed-in code block for each Git repository in the tree
  def each(repo, config={})
    @counter += 1
    parent_dir = Dir.pwd

    # Perform the action (downwards recursion)
    nest_to("#{repo.path}")
    if config[:recurse_down]
      yield
    end

    if (config[:not_recursive] == nil) && (repo.submodules.length > 0)
      puts "#{indent}Recursing into #{repo.path} ...".cyan

      repo.submodules.each do |submodule|
        each(submodule, config) do
          yield
        end
      end
    end

    # Perform the action (upwards recursion)
    unless config[:recurse_down]
      yield
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


  def nest_to(dir)
    Dir.chdir(dir)
    @depth += 1
    if nesting > @max_nesting then @max_nesting = nesting end
  end


  def denest_to(parent_dir)
    Dir.chdir(parent_dir)
    @depth -= 1
  end

end
