require 'colorize'
require 'rake/testtask'


namespace :base do
  task :install do
     system("bundle install")
  end


  desc 'Clean temporary files.'
  task :clean do
    system("find . -name '*~' -delete")
    system("find . -name '*.class' -delete")
    # Mess created by git merge
    system("find . -name '*.orig' -delete")
    system("find . -name '*.BACKUP*' -delete")
    system("find . -name '*.BASE*' -delete")
    system("find . -name '*.LOCAL*' -delete")
    system("find . -name '*.REMOTE*' -delete")
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
