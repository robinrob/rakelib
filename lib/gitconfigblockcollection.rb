class GitConfigBlockCollection

  attr_accessor :blocks

  def initialize(blocks)
    @blocks = blocks
  end


  def each(&block)
    @blocks.each(&block)
  end


  def [](index)
    @blocks[index]
  end


  def []=(index, value)
    @blocks[index] = value
  end


  def length
    @blocks.length
  end


  def sort!
    @blocks.sort_by! { |block| block.name.downcase }
    self
  end

end