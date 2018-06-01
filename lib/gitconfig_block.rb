# GitConfigBlock models a section of gitconfig-type file, such as a submodule declaration within a .gitmodules file.
#
# GitConfigBlock reads in a section of text that represents a gitconfig block and provides an interface to the values
# within that block.
#
# GitConfigBlock also provides an interface to 'derived' attributes, such as the 'owner' of a submodule represented by a
# .gitmodules declaration block.

class GitConfigBlock
  AttributeIndent = 2

  attr_accessor :name, :type, :attrs, :derived_attrs


  def initialize(lines)
    unless lines.instance_of? Hash
      block = read(lines)
    else
      block = lines
    end

    @type = block[:type]
    @name = block[:name]
    @attrs = block[:attrs]
    @derived_attrs = block[:derived_attrs]
  end


  def to_s
    str = "[#{@type} \"#{@name}\"]\n"
    @attrs.keys.each do |key|
      str += "  #{key} = #{@attrs[key]}\n"
    end
    str
  end


  def eql?(other)
    diff(other) == nil
  end


  def diff(other)
    diff = nil
    diff = :type unless self.type == other.type
    diff = :name unless self.name == other.name
    diff = :attrs unless self.attrs == other.attrs
    diff = :derived_attrs unless self.derived_attrs == other.derived_attrs
    diff
  end


  private
  def read(lines)
    block = {}
    block[:attrs] = {}
    block[:derived_attrs] = {}

    lines.each_line.with_index do |line, index|
      if index == 0
        comps = line.scan(/[^\"\s\[\]]+/)
        block[:type] = comps[0]
        block[:name] = comps[1]

      elsif line.match(/.*=.*/)
        key, val = line.split('=').collect {|comp| comp.strip!}
        block[:attrs][key.to_sym] = val
      end
    end
    block = calc_derived_attrs(block)

    block
  end


  def calc_derived_attrs(block)
    unless block[:attrs][:url].nil?
      block[:derived_attrs][:owner] = parse_owner(block[:attrs][:url])
    end

    block
  end


  def parse_owner(repo_url)
    match_groups = repo_url.scan(/(?:bitbucket.org|github.com)(?::|\/)([\S]+)\/.*/)
    if match_groups.count > 0
      match_groups[0][0]
    else
      "robinrob"
    end
  end
end