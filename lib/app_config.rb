module AppConfig

  DEBUG = false

  DATE_FORMAT = "%Y-%m-%d_%H_%M_%S"

  GITHUB_USER = ENV['GITHUB_USER']

  SECRETS = {
      :github_password => ENV['GITHUB_PASS']
  }

end
