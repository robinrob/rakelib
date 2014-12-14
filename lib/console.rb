require 'colorize'
require 'differ'


# Class to make it easy to output stuff to the console from unit tests!!
# Tired of having to remember or find the trick to do it.

module Console
  def self.thefuckout(msg)
    $stdout, $stderr = STDOUT, STDERR
    $stdout.puts "\nBEGIN OUTPUT>>>".cyan
    $stdout.puts msg
    $stdout.puts "<<<END OUTPUT".cyan
  end


  # Show diff of two strings
  def self.diff_str(str1, str2)
    diff = Differ.diff(str1, str2).to_s
    self.show_diff(str1, str2, diff)
  end


  # Show diff of two objects
  def self.diff_obj(obj1, obj2)
    self.show_diff(obj1, obj2, obj1.diff(obj1))
  end


  # Compare expected, actual and diff of two strings with pretty console output
  def self.show_diff(expected, actual, diff)
    Console.thefuckout "Should be:".light_red
    Console.thefuckout expected.inspect.green

    Console.thefuckout "Actually:".light_red
    Console.thefuckout actual.inspect.yellow

    Console.thefuckout "Diff:".light_red
    Console.thefuckout diff.to_s.light_red
  end
end