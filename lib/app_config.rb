# AppConfig encapsulates the application config by providing a common interface to all parts of the application.
#
# Only AppConfig should have to worry about how to actually read configuration values into the configuration constants.

module AppConfig

  Debug = false

  DateFormat = "%Y-%m-%d_%H_%M_%S"

  GithubUser = ENV['GITHUB_USER']

  # This can be used by AppLogger to filter out any credentials from the log output - in case they have crept into a log
  # statement somewhere.
  Secrets = {
      :github_password => ENV['GITHUB_PASS']
  }

end
