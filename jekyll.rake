namespace :jekyll do

  desc 'Start Jekyll server.'
	task :server => [:kill, :haml] do
	  system("jekyll serve --watch")
	end


  desc 'Kill Jekyll server.'
  task :kill do
   system("killp jekyll")
  end


  desc "Generate HTML from HAML"
  task :haml => ['cv/index.html']


  desc "Generate CV HTML from HAML"
  file 'cv/index.html' => 'cv/index.haml' do
    puts "Generating cv/index.html from cv/index.haml".magenta
    sh 'rm -f cv/index.html'
    sh 'cv/meta.sh > cv/index.html && haml cv/index.haml >> cv/index.html'
  end


  desc "Clean Jekyll project"
  task :clean => 'base:clean' do
    sh "rm -rf '.sass_cache'"
    sh "rm -rf '_site'"
  end


  task :save, [:msg, :remote] => ['jekyll:haml', 'base:save']

end

