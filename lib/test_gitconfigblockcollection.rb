$LOAD_PATH << '.'

require 'test/unit'
require 'assert'
require 'gitconfigblock'
require 'gitconfigblockbuilder'
require 'gitconfigblockcollection'


class TestGitConfigBlock < Test::Unit::TestCase

  RubyGitConfigBlock = GitConfigBlockBuilder.new.with_type('submodule').
      with_name('ruby').
      with_attrs({
                     :path => 'ruby',
                     :url => 'git@bitbucket.org:robinrob/ruby.git',
                     :branch => 'master'}).
      with_derived_attrs({
                             :owner => 'robinrob'
                         }).
      build


  def test_should_iterate_over_3_gitconfigblocks
    ruby_block = RubyGitConfigBlock
    blocks = [ruby_block, ruby_block, ruby_block]
    collection = GitConfigBlockCollection.new(blocks)

    collected_blocks = collection.each do |block|
      block
    end

    assert_equal(3, collected_blocks.length)
  end


  def test_should_iterate_over_3_ruby_gitconfigblocks
    ruby_block = RubyGitConfigBlock
    blocks = [ruby_block, ruby_block, ruby_block]
    collection = GitConfigBlockCollection.new(blocks)

    collection.each do |block|
      assert(Assert.equal_objs(ruby_block, block))
    end
  end


  def test_should_index_collection
    ruby_block = RubyGitConfigBlock
    expected = ruby_block.dup
    expected.name = 'Robin'
    blocks = [ruby_block, expected, ruby_block]
    collection = GitConfigBlockCollection.new(blocks)

    second = blocks[1]

    assert(Assert.equal_objs(expected, second))
  end


  def test_should_assign_to_collection_index
    ruby_block = RubyGitConfigBlock
    expected = ruby_block.dup
    expected.name = 'Robin'
    blocks = [ruby_block, ruby_block, ruby_block]
    collection = GitConfigBlockCollection.new(blocks)

    collection[1] = expected

    assert(Assert.equal_objs(expected, collection[1]))
  end


  def test_should_be_correct_length
    ruby_block = RubyGitConfigBlock
    blocks = [ruby_block, ruby_block, ruby_block]
    collection = GitConfigBlockCollection.new(blocks)

    length = collection.length

    assert_equal(3, length)
  end


  def test_should_sort_alphabetically
    ruby_block = RubyGitConfigBlock
    first = ruby_block.dup
    first.name = 'C'
    second = ruby_block.dup
    second.name = 'b'
    third = ruby_block.dup
    third.name = 'A'
    blocks = [first, second, third]
    collection = GitConfigBlockCollection.new(blocks)

    collection.sort!

    assert(Assert.equal_objs(third, collection[0]))
    assert(Assert.equal_objs(first, collection[-1]))
  end


end