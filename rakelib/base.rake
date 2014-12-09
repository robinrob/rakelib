require 'colorize'
require 'rake/testtask'


task :install do
   system("bundle install")
end


desc 'Clean temporary files.'
task :clean do
  system("find . -name '*~' -delete")
  # Mess created by git merge
  system("find . -name '*.orig' -delete")
  system("find . -name '*.BACKUP*' -delete")
  system("find . -name '*.BASE*' -delete")
  system("find . -name '*.LOCAL*' -delete")
  system("find . -name '*.REMOTE*' -delete")
  system("find . -name '*.class' -delete")
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
task :save, [:msg] => ['git:commit', 'git:pull', 'git:push'] do |t, args|
end
