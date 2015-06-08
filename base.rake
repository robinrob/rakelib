require 'colorize'
require 'rake/testtask'


namespace :base do
  task :install do
     system("bundle install")
  end


  desc 'Clean temporary files.'
  task :clean do
    find_delete('*~')
    find_delete('*.class')
    find_delete('*.orig')
    find_delete('*.BACKUP*')
    find_delete('*.BASE*')
    find_delete('*.LOCAL*')
    find_delete('*.REMOTE*')
  end


  def find_delete(pattern)
    system("find . -maxdepth 1 -name '#{pattern}' -delete")
  end


  desc 'Run tests.'
  task :test, [:test_files] do |t, args|
    test_files = args[:test_files] || FileList['test*.rb', 'lib/test*.rb']
    Rake::TestTask.new do |t|
      t.libs << "."
      t.test_files = test_files
      t.verbose = true
    end
  end


  desc 'Stage, commit, pull & push.'
  task :save, [:msg, :remote] => ['git:commit'] do |t, args|
    remote = ENV['remote'] || args[:remote] || ENV['DEFAULT_GIT_REMOTE']

    Rake::Task["git:pull"].invoke(remote)
    Rake::Task["git:push"].invoke(remote)
  end
end


def git_changes
  modified = `git ls-files --modified 2> /dev/null`
  untracked = `git ls-files --others 2> /dev/null`

  !modified.empty? or !untracked.empty?
end
