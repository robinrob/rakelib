$LOAD_PATH << '.'
$LOAD_PATH << 'rake'

require 'gitconfigblock'

# Reads a file with format of .gitconfig, for example .gitmodules and returns an array of hashes.
# Each hash represents a block of the config file, containing the config in a 'flat' csv-like structure.
class GitConfigReader

  def read(filename='.gitconfig')
    text = File.read(filename)
    text.strip!

    blocks = []

    text.split(/(\[.*\])/)[1..-1].each_slice(2) { |block_str| blocks << GitConfigBlock.new(block_str.join) }

    blocks
  end

end