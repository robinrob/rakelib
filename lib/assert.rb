require 'exceptions'
require 'console'
require 'differ'

module Assert

  def self.equal_strings(expected, actual)
    equal = true
    if expected != actual
      equal = false
      diff = Differ.diff_by_line(actual, expected).to_s.light_red
      Console.show_diff(expected, actual, diff)
    end
    equal
  end


  def self.assert &block
    raise AssertionError unless yield
  end


  def self.equal_objs(expected, actual)
    diff = expected.diff actual
    equal = true
    if (diff) != nil
      equal = false
      Console.show_diff expected, actual, diff
    end
    equal
  end
end