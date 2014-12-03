require 'gitconfigblock'

class GitConfigBlockBuilder


  def with_type(type)
    @type = type
    self
  end


  def with_name(name)
    @name = name
    self
  end


  def with_attrs(attrs)
    @attrs = attrs
    self
  end


  def with_derived_attrs(derived_attrs)
    @derived_attrs = derived_attrs
    self
  end


  def build(num=1)
    block = GitConfigBlock.new({
                                   :type => @type,
                                   :name => @name,
                                   :attrs => @attrs,
                                   :derived_attrs => @derived_attrs
                               })
    if num > 1
      [block] * num
    else
      block
    end
  end

end