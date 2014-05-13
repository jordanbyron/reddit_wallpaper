require 'open-uri'
require 'ruby_reddit_api'
require 'open_uri_redirections'

class RedditWallpaper
  def initialize(subreddit, destination_file)
    @subreddit      = subreddit
    @path           = destination_file
    @downloaded     = []
    @not_downloaded = []
  end

  attr_reader :path, :subreddit, :downloaded, :not_downloaded

  def download_new_image
    posts = reddit.browse(subreddit)
    posts.each do |post|
      if post.url.include?('imgur') && !downloaded.include?(post.url)
        not_downloaded << post.url
      end
    end

    download_image not_downloaded.shift
  end

  private

  def reddit
    @reddit ||= Reddit::Api.new
  end

  def download_image(url)
    # Append .jpg to ensure we are getting the image file
    open(path, 'wb') do |file|
      file << open(url + ".jpg", allow_redirections: :all).read
    end
    downloaded << url
  end
end
