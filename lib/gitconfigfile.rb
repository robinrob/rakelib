require 'assert'
require 'gitconfigreader'
require 'gitconfigblockcollection'

class GitConfigFile

  attr_accessor :blocks


  def initialize(options={})
    filename = options[:filename] || '.gitconfig'
    blocks = options[:blocks] || nil

    @filename = filename

    if blocks.nil?
      if File.exists? filename
        @blocks = GitConfigReader.new.read(filename)
      else
        raise FileNotFoundException
      end

    else
      @blocks = blocks
    end

  end


  def serialize
    str = ""
    @blocks.each do |block|
      str += block.to_s
    end
    str
  end


  def save
    File.open(@filename, "w") do |file|
      file.write(serialize)
    end
  end


  def contents
    File.open(@filename, "r") do |infile|
      contents = ""
      while (line = infile.gets)
        contents << line
      end
      contents
    end
  end


  def get_block(block_name)
    @blocks.find { |block| block.name == block_name }
  end


  def del_block(block_name)
    @blocks.delete(get_block(block_name))
  end


  def blocks
    GitConfigBlockCollection.new(@blocks)
  end


  def sort!
    @blocks = blocks.sort!.blocks
    self
  end

end