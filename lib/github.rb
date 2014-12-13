require 'httparty'
require 'app_logger'
require 'colorize'

class Github
  include HTTParty
  base_uri "https://api.github.com"

  def initialize(username, password)
    @auth = { :username => username, :password => password}

    @log = AppLogger.new
  end


  public
  def import
    repo_name = `basename #{ENV['PWD']}`.strip

    repo_url = "git@bitbucket.org:#{@auth[:username]}/#{repo_name}.git"
    new_url = "git@github.com:#{@auth[:username]}/#{repo_name}.git"

    created = false
    @log.info "Creating new repository in Github: #{new_url}"
    response = create_repo repo_name, repo_name
    if response.has_key? "id"
      @log.info "Request successful.".green
      created = true
    else
      @log.info "Response: #{response}".red
    end

    if created
      @log.info "Pushing to new repository: #{new_url}"
      `git remote add github #{new_url}`
      `git push github master`
    end
  end


  private
  def create_repo(name, description="")
    options = {
        :body => {
            :name => name, :description => description
        }.to_json,
        :basic_auth => @auth,
        :headers => {
            'User-Agent' => 'robinrob'
        }
    }

    response = self.class.post("/user/repos", options)
  end


  def delete_repo name
    self.class.delete("/repos/#{@auth[:username]}/#{name}", :basic_auth => @auth)
  end


  def test_request
    reponse = self.class.get("/users/#{@auth[:username]}/repos")
  end

  def save_repo_slugs_to_file
    open('repo-slugs.txt', 'w') do |f|
      @bitbucket_repos.each do |repo|
        f.puts repo[:name]
      end
    end
  end

  private

  #def load_bitbucket_repos
  #  response = HTTParty.get "https://api.bitbucket.org/1.0/users/#{@auth[:username]}/" # My username is the same for bitbucket and github
  #  @bitbucket_repos = response['repositories'].map { |repo| {:name => repo["slug"], :description => repo['description']}}
  #end

end