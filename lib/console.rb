require 'colorize'
require 'differ'

module Console
  def self.thefuckout(msg)
    $stdout, $stderr = STDOUT, STDERR
    $stdout.puts "\nBEGIN OUTPUT>>>".cyan
    $stdout.puts msg
    $stdout.puts "<<<END OUTPUT".cyan
  end


  def self.diff_str(str1, str2)
    diff = Differ.diff(str1, str2).to_s
    self.show_diff(str1, str2, diff)
  end


  def self.diff_obj(obj1, obj2)
    self.show_diff(obj1, obj2, obj1.diff(obj1))
  end


  def self.show_diff(expected, actual, diff)
    Console.thefuckout "Should be:".light_red
    Console.thefuckout expected.inspect.green

    Console.thefuckout "Actually:".light_red
    Console.thefuckout actual.inspect.yellow

    Console.thefuckout "Diff:".light_red
    Console.thefuckout diff.to_s.light_red
  end
end