namespace :img do

  task :quantize, [:file] do
    system("pngquant --ext .quant --quality 20 80 #{args[:file]}")
  end

end