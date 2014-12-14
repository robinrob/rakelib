require 'exceptions'
require 'console'
require 'differ'


# Assert provides some custom assertion logic for unit tests.

module Assert

  # Display diff of two strings and return true/false to indicate equality.
  def self.equal_strings(expected, actual)
    equal = true
    if expected != actual
      equal = false
      diff = Differ.diff_by_line(actual, expected).to_s.light_red
      Console.show_diff(expected, actual, diff)
    end
    equal
  end


  # Display diff of two objects and return true/false to indicate equality.
  def self.equal_objs(expected, actual)
    diff = expected.diff actual
    equal = true
    if (diff) != nil
      equal = false
      Console.show_diff expected, actual, diff
    end
    equal
  end


  # Assert that a block returns true, raise AssertionError otherwise.
  def self.assert &block
    raise AssertionError unless yield
  end
end