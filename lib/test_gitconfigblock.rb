$LOAD_PATH << '.'

require 'test/unit'
require 'gitconfigblock'
require 'gitconfigblockbuilder'


class TestGitConfigBlock < Test::Unit::TestCase

  TestString = <<-END
[submodule "rake"]
  path = rake
  url = git@bitbucket.org:robinrob/rakefile.git
END

  MrRobinSmithCom = <<-END
[submodule "mrrobinsmith.com"]
  path = mrrobinsmith.com
  url = git@bitbucket.org:robinrob/mrrobinsmith.com.git
END

  GithubUrl = <<-END
[submodule "mrrobinsmith.com"]
  path = mrrobinsmith.com
  url = git@github.com:robinrob/mrrobinsmith.com.git
END

  GithubHttpsUrl = <<-END
[submodule "mrrobinsmith.com"]
  path = mrrobinsmith.com
  url = https://github.com:robinrob/mrrobinsmith.com.git
END

  BitbucketHttpsUrl = <<-END
[submodule "mrrobinsmith.com"]
  path = mrrobinsmith.com
  url = https://bitbucket.org:robinrob/mrrobinsmith.com.git
END


  PreztoUrl = <<-END
[submodule "mrrobinsmith.com"]
  path = mrrobinsmith.com
  url = https://github.com/sorin-ionescu/prezto.git
END



  def test_should_read_block
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert(block.instance_of?(GitConfigBlock))
  end


  def test_should_read_block_type
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('submodule', block.type)
  end


  def test_should_read_block_name
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('rake', block.name)
  end


  def test_should_read_path_attr
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('rake', block.attrs[:path])
  end


  def test_should_read_url_attr
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('git@bitbucket.org:robinrob/rakefile.git', block.attrs[:url])
  end


  def test_should_derive_owner_of_bitbucket_repo
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('robinrob', block.derived_attrs[:owner])
  end


  def test_should_derive_owner_of_https_bitbucket_repo
    lines = BitbucketHttpsUrl

    block = GitConfigBlock.new(lines)

    assert_equal('robinrob', block.derived_attrs[:owner])
  end


  def test_should_derive_owner_of_github_repo
    lines = GithubUrl

    block = GitConfigBlock.new(lines)

    assert_equal('robinrob', block.derived_attrs[:owner])
  end


  def test_should_derive_owner_of_https_github_repo
    lines = GithubHttpsUrl

    block = GitConfigBlock.new(lines)

    assert_equal('robinrob', block.derived_attrs[:owner])
  end


  def test_should_derive_owner_of_prezto_url
    lines = PreztoUrl

    block = GitConfigBlock.new(lines)

    assert_equal('sorin-ionescu', block.derived_attrs[:owner])
  end


  def test_should_convert_block_to_string
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal(lines, block.to_s)
  end


  def test_should_parse_mrrobinsmith_com_correctly
    lines = MrRobinSmithCom

    block = GitConfigBlock.new(lines)

    assert_equal(lines, block.to_s)
  end


  def test_should_be_equal_to_other_block
    attrs = {:attr1 => 'attr1', :attr2 => 'attr2'}
    derived_attrs = {:attr1 => 'derived_attr1', :attr2 => 'derived_attr2'}
    block1 = GitConfigBlockBuilder.new.with_type('type').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build
    block2 = GitConfigBlockBuilder.new.with_type('type').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build

    are_equal = block1.eql? block2

    assert(are_equal)
  end


  def test_should_not_be_equal_to_other_block
    attrs = {:attr1 => 'attr1', :attr2 => 'attr2'}
    derived_attrs1 = {:attr1 => 'derived_attr1', :attr2 => 'derived_attr2'}
    derived_attrs2 = {:attr1 => 'derived_attr1', :attr2 => 'derived_attr3'}
    block1 = GitConfigBlockBuilder.new.with_type('type').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs1).
        build
    block2 = GitConfigBlockBuilder.new.with_type('type').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs2).
        build

    are_equal = block1.eql? block2

    assert(!are_equal)
  end


  def test_should_differ_by_type
    attrs = {:attr1 => 'attr1', :attr2 => 'attr2'}
    derived_attrs = {:attr1 => 'derived_attr1', :attr2 => 'derived_attr2'}
    block1 = GitConfigBlockBuilder.new.with_type('type1').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build
    block2 = GitConfigBlockBuilder.new.with_type('type2').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build

    diff = block1.diff block2

    assert_equal(:type, diff)
  end


  def test_should_not_differ
    attrs = {:attr1 => 'attr1', :attr2 => 'attr2'}
    derived_attrs = {:attr1 => 'derived_attr1', :attr2 => 'derived_attr2'}
    block1 = GitConfigBlockBuilder.new.with_type('type').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build
    block2 = GitConfigBlockBuilder.new.with_type('type').
        with_name('name').
        with_attrs(attrs).
        with_derived_attrs(derived_attrs).
        build

    diff = block1.diff block2

    assert_equal(nil, diff)
  end

end
