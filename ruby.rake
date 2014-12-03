require 'colorize'

task :hashes do
  desc 'Replace all new-syntax hashes in the project with hash-rocket syntax.'
  cmd = "gfind . -iregex '.*\\(rb\\|haml\\)' -printf '%p\n'"
  files = `#{cmd}`.split("\n")

  files.each do |file|
    puts "Converting file: ".green << "#{file}".yellow
    `gsed -i "s/\\([a-z_]\\+\\):\\{1\\}\s\\+\\(\\('\\|"'"'"\\)\\?[-a-zA-Z0-9{}:@]\\+\\('\\|"'"'"\\)\\?\\)/:\\1 => \\2/g" #{file}`
  end
end
