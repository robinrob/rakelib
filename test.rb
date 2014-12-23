#!/usr/bin/env ruby

  modified = `git ls-files --modified 2> /dev/null`
  
  if modified
    puts "hello"
  end

