require 'subdoer'
require 'github'
require 'app_config'

class GitRepo

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
    doer.each_sub(self, command, config)
    {
        :max_nesting => doer.max_nesting,
        :counter => doer.counter
    }
  end


  def export_all
    doer = SubDoer.new
    doer.foreach(self) do
      github = Github.new AppConfig::GITHUB_USER, AppConfig::SECRETS[:github_password]
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


  def export_to_github
    github = Github.new AppConfig::GITHUB_USER, AppConfig::SECRETS[:github_password]
    github.import :name
  end
end