#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'github'
require 'app_config'

Repo=ARGV[0]

github = Github.new AppConfig::GITHUB_USER, AppConfig::SECRETS[:github_password]
github.import Repo