require 'open-uri'
require 'ruby_reddit_api'

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
    open(path, 'wb') {|file| file << open(url + ".jpg").read }
    downloaded << url
  end
end
