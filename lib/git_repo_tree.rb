require 'git_sub_doer'
require 'github'
require 'app_config'


# GitRepoTree models a Git repository.
#
# GitRepoTree uses any .gitmodules file existent in the repository path that it is initialised with, to populate a
# reference to submodule Git repositories that are in turn each modelled as a GitRepoTree.
#
# GitRepoTree provides an interface for actions related to submodule management, that can be run recursively on all the
# Git repositories linked through the GitRepoTree. The tree includes the Git repository whose path is used to initialise
# GitRepoTree and all of the submodules of that repository. I.e. it is 'inclusive' of the parent repository that is
# initalised.

class GitRepoTree

  Me = 'robinrob'

  attr_accessor :name, :submodules, :owner, :path

  def initialize(config)
    @name = config[:name]
    @path = config[:path]
    @submodules = []
    fill_submodules
    @owner = config[:owner] || Me
  end


  def each_sub(command, config={})
    doer = SubDoer.new
    doer.each_exec(self, command, config)
    {
        :max_nesting => doer.max_nesting,
        :counter => doer.counter
    }
  end


  def export_to_github
    github = Github.new AppConfig::GithubUser, AppConfig::Secrets[:github_password]
    github.import :name
  end


  def export_all_to_github
    doer = SubDoer.new
    doer.each(self) do
      github = Github.new AppConfig::GithubUser, AppConfig::Secrets[:github_password]
      github.import
    end
  end


  private
  def fill_submodules
    begin
      if File.exists? '.gitmodules'
        blocks = GitConfigReader.new.read '.gitmodules'
        blocks.each do |block|
          parent = Dir.pwd
          Dir.chdir block.attrs[:path]
          add_sub GitRepo.new({
                                  :name => block.name,
                                  :path => block.attrs[:path],
                                  :owner => block.derived_attrs[:owner]
                              })
          Dir.chdir parent
        end
      end
    rescue Exception => e
      puts "Error parsing submodules for repo: #{`pwd`}"
      puts e.message
      puts e.backtrace
    end
  end


  def add_sub(sub)
    @submodules << sub
  end
end