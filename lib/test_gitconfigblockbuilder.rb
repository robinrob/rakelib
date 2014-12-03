$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigblockbuilder'


class TestGitConfigBlockBuilder < Test::Unit::TestCase


  def test_build_gitconfigblock_with_type
    type = 'submodule'

    block = GitConfigBlockBuilder.new.with_type(type).build

    assert_equal(type, block.type)
  end


  def test_build_gitconfigblock_with_name
    name = 'Robin Smith'

    block = GitConfigBlockBuilder.new.with_name(name).build

    assert_equal(name, block.name)
  end


  def test_build_gitconfigblock_with_attrs
    attrs = {:url => 'git@bitbucker.org:robinrob/robin.git', :path => 'robin'}

    block = GitConfigBlockBuilder.new.with_attrs(attrs).build

    assert_equal(attrs, block.attrs)
  end


  def test_build_gitconfigblock_with_derived_attrs
    derived_attrs = {:url => 'git@bitbucker.org:robinrob/robin.git', :path => 'robin'}

    block = GitConfigBlockBuilder.new.with_derived_attrs(derived_attrs).build

    assert_equal(derived_attrs, block.derived_attrs)
  end


  def test_build_2_gitconfigblocks
    type = 'submodule'
    name = 'robin'
    attrs = {:url => 'git@bitbucker.org:robinrob/robin.git', :path => 'robin'}

    blocks = GitConfigBlockBuilder.new.with_type(type).with_name(name).with_attrs(attrs).build(2)

    assert_equal(2, blocks.length)
    blocks.each do |block|
      assert(block.instance_of? GitConfigBlock)
    end
  end

end
