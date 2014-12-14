$LOAD_PATH << '.'
$LOAD_PATH << 'rake'

require 'gitconfig_block'

# GitConfigReader reads a .gitconfig-style configuration file into a GitConfigBlockCollection.

class GitConfigReader

  def read(filename='.gitconfig')
    text = File.read(filename)
    text.strip!

    blocks = []

    text.split(/(\[.*\])/)[1..-1].each_slice(2) { |block_str| blocks << GitConfigBlock.new(block_str.join) }

    blocks
  end

end