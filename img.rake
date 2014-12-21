namespace :img do

  task :quant, [:file] do |t, args|
    system("pngquant --force --ext .quant --quality 20 80 #{args[:file]}")
  end

end
