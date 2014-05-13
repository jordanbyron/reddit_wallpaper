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
      if download? post.url
        not_downloaded << post.url
      end
    end

    download_image not_downloaded.shift
  end

  private

  # Checks that the post url is either a jpg file or hosted on imgur
  #
  def download?(url)
    url[/(imgur|\.jpe?g\z)/] && !downloaded.include?(url)
  end

  def reddit
    @reddit ||= Reddit::Api.new
  end

  def download_image(url)
    # Append .jpg to ensure we are getting the image file from imgur
    url += ".jpg" unless url[/\.jpe?g\z/]

    open(path, 'wb') do |file|
      file << open(url, allow_redirections: :all).read
    end
    downloaded << url
  end
end
