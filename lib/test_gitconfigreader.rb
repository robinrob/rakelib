$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigreader'
require 'gitconfigblock'


class TestGitConfigReader < Test::Unit::TestCase

  TestFilename = '.gitconfig_test'

  def setup
    gitconfig_contents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
  branch = master
[submodule "c"]
  path = c
  url = git@bitbucket.org:robinrob/c.git
  branch = master
[submodule "c-plus-plus"]
  path = c-plus-plus
  url = git@bitbucket.org:robinrob/c-plus-plus.git
  branch = master
[submodule "force.com"]
  path = force.com
  url = git@bitbucket.org:robinrob/force.com.git
  branch = master
[submodule "html-css"]
  path = html-css
  url = git@bitbucket.org:robinrob/html-css.git
  branch = master
[submodule "java"]
  path = java
  url = git@bitbucket.org:robinrob/java.git
  branch = master
[submodule "javascript"]
  path = javascript
  url = git@bitbucket.org:robinrob/javascript.git
  branch = master
[submodule "perl"]
  path = perl
  url = git@bitbucket.org:robinrob/perl.git
  branch = master
[submodule "python"]
  path = python
  url = git@bitbucket.org:robinrob/python.git
  branch = master
[submodule "ruby"]
  path = ruby
  url = git@bitbucket.org:robinrob/ruby.git
  branch = master
END
    File.open(TestFilename, File::WRONLY | File::CREAT) do |file|
      file.write(gitconfig_contents)
    end
  end


  def teardown
    File.delete TestFilename
  end


  def test_should_read_10_blocks()
    reader = GitConfigReader.new

    blocks = reader.read(filename=TestFilename)

    assert_equal(10, blocks.length)
  end


  def test_should_read_10_gitconfigblocks()
    reader = GitConfigReader.new

    blocks = reader.read(filename=TestFilename)

    blocks.each do |block|
      assert(block.instance_of? GitConfigBlock)
    end
  end

  def test_should_read_force_com_block_correctly()
    reader = GitConfigReader.new

    blocks = reader.read(filename=TestFilename)

    block = blocks.find { |block| block.name == 'force.com' }
    assert_not_nil block
  end

end