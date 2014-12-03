$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigfile'
require 'gitconfigblockbuilder'
require 'differ'
require 'console'
require 'exceptions'


class TestGitConfigFile < Test::Unit::TestCase

  TestFilename = '.gitconfig_test'

  GitSubmoduleContents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
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
[submodule "ruby"]
  path = ruby
  url = git@bitbucket.org:robinrob/ruby.git
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
[submodule "c"]
  path = c
  url = git@bitbucket.org:robinrob/c.git
  branch = master
[submodule "python"]
  path = python
  url = git@bitbucket.org:robinrob/python.git
  branch = master
END

  EditedContents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
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
[submodule "c"]
  path = c
  url = git@bitbucket.org:robinrob/c.git
  branch = master
[submodule "python"]
  path = python
  url = git@bitbucket.org:robinrob/python.git
  branch = master
END


  def teardown
    File.delete('.gitconfig') if File.exists? '.gitconfig'
  end


  def test_should_raise_file_not_found_exception_when_file_does_not_exist
    assert_raises FileNotFoundException do
      GitConfigFile.new
    end
  end


  def test_should_read_gitconfig_contents_by_default
    expected = GitSubmoduleContents
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    contents = file.contents

    assert_equal(expected, contents)
  end


  def test_should_read_gitsubmodule_contents
    expected = GitSubmoduleContents
    filename = 'gitsubmodules'
    File.open(filename, 'w') {|file| file.write(expected)}
    file = GitConfigFile.new(:filename => filename)

    contents = file.contents

    File.delete(filename)
    assert_equal(expected, contents)
  end


  def test_should_read_gitconfig_contents_into_1_gitconfigblock
    expected = expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
END
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    blocks = file.blocks

    assert_equal(1, blocks.length)
  end


  def test_should_read_gitconfig_block_type
    expected = expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
END
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    blocks = file.blocks

    assert_equal(blocks[0].type, 'submodule')
  end


  def test_should_read_gitconfig_block_name
    expected = expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
    END
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    blocks = file.blocks

    assert_equal(blocks[0].name, 'robin')
  end


  def test_should_read_gitconfig_block_url_attribute
    expected = expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
    END
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    blocks = file.blocks

    assert_equal('git@bitbucket.org:robinrob/robin.git', blocks[0].attrs[:url])
  end

  
  def test_should_read_2_gitconfig_block_attributes
    expected = expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
END
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    blocks = file.blocks

    assert_equal(2, blocks[0].attrs.length)
  end


  def test_should_read_9_gitconfig_blocks
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    blocks = file.blocks

    assert_equal(10, blocks.length)
  end


  def test_should_read_first_gitconfig_block_correctly
    attrs = {:path => 'awk', :url => 'git@bitbucket.org:robinrob/awk.git', :branch => 'master'}
    derived_attrs = {:owner => 'robinrob'}
    expected = GitConfigBlockBuilder.new.with_type('submodule').
        with_name('awk').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    block = file.blocks[0]

    assert(Assert.equal_objs(expected, block))
  end


  def test_should_read_last_gitconfig_block_correctly
    attrs = {:path => 'python', :url => 'git@bitbucket.org:robinrob/python.git', :branch => 'master'}
    derived_attrs = {:owner => 'robinrob'}
    expected = GitConfigBlockBuilder.new.
        with_type('submodule').
        with_name('python').
        with_attrs(attrs).with_derived_attrs(derived_attrs).
        build
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    block = file.blocks[-1]

    assert(Assert.equal_objs(expected, block))
  end


  def test_should_serialize_1_gitconfigblock
    type = 'submodule'
    name = 'robin'
    attrs = {:url => 'git@bitbucket.org:robinrob/robin.git', :path => 'robin'}
    blocks = [GitConfigBlockBuilder.new.with_type(type).with_name(name).with_attrs(attrs).build]
    file = GitConfigFile.new(:blocks => blocks)
    expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
    END

    str = file.serialize

    assert_equal(expected, str)
  end


  def test_should_serialize_10_gitconfigblocks
    type = 'submodule'
    name = 'robin'
    attrs = {:url => 'git@bitbucket.org:robinrob/robin.git', :path => 'robin'}
    blocks = [GitConfigBlockBuilder.new.with_type(type).with_name(name).with_attrs(attrs).build] * 10
    file = GitConfigFile.new(:blocks => blocks)
    expected = <<-END
[submodule "robin"]
  url = git@bitbucket.org:robinrob/robin.git
  path = robin
    END
    expected = ([expected] * 10).join

    str = file.serialize

    assert_equal(expected, str)
  end


  def test_should_save_new_file
    expected = GitSubmoduleContents
    File.open('.gitconfig', 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    file.save

    contents = File.read('.gitconfig')
    assert(Assert.equal_strings(expected, contents))
  end


  def test_should_get_ruby_submodule_block()
    attrs = {:path => 'ruby', :url => 'git@bitbucket.org:robinrob/ruby.git', :branch => 'master'}
    derived_attrs = {:owner => 'robinrob'}
    expected = GitConfigBlockBuilder.new.with_type('submodule').
        with_name('ruby').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    block = file.get_block 'ruby'

    assert(Assert.equal_objs(expected, block))
  end


  def test_should_del_1_submodule_block()
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    block = file.del_block 'ruby'

    assert_equal(9, file.blocks.length)
  end


  def test_should_del_ruby_submodule_block()
    attrs = {:path => 'ruby', :url => 'git@bitbucket.org:robinrob/ruby.git', :branch => 'master'}
    derived_attrs = {:owner => 'robinrob'}
    expected = GitConfigBlockBuilder.new.with_type('submodule').
        with_name('ruby').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    block = file.del_block 'ruby'

    assert(Assert.equal_objs(expected, block))
  end


  def test_should_read_and_delete()
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}

    file = GitConfigFile.new; file.del_block 'ruby';

    assert(Assert.equal_strings(EditedContents, file.serialize))
  end


  def test_should_read_delete_and_save()
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}

    file = GitConfigFile.new; file.del_block 'ruby'; file.save

    assert(Assert.equal_strings(EditedContents, file.contents))
  end


  def test_should_sort_alphabetically
    File.open('.gitconfig', 'w') {|file| file.write(GitSubmoduleContents)}
    file = GitConfigFile.new

    file.sort!

    assert_equal('c', file.blocks[1].name)
  end

end
