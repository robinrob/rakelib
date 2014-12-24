namespace :jekyll do

  desc 'Start Jekyll server.'
	task :server => [:kill, :haml] do
	  system("jekyll serve --watch")
	end


  desc 'Kill Jekyll server.'
  task :kill do
   system("killp jekyll")
  end


  desc "Convert HAML to html"
  task :haml => ['cv/index.haml']


  desc "Convert HAML to html"
  file 'cv/index.haml' => 'cv/index.html' do
    puts "Converting cv/index.haml => cd/index.html".magenta
    rm 'cv/index.html'
    sh 'cv/meta.sh > cv/index.html && haml cv/index.haml >> cv/index.html'
  end

  desc "Clean Jekyll project"
  task :clean do
    system("rm -rf '.sass_cache'")
    system("rm -rf '_site'")
  end


  task :save, [:msg, :remote] => ['jekyll:haml', 'base:save']

end

