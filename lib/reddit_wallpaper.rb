require 'open-uri'
require 'ruby_reddit_api'
require 'open_uri_redirections'

class RedditWallpaper
  def self.reddit
    @reddit ||= Reddit::Api.new
  end

  def initialize(subreddit, destination_file)
    @subreddit      = subreddit
    @path           = destination_file
    @downloaded     = []
    @not_downloaded = []
  end

  attr_reader :path, :subreddit, :downloaded, :not_downloaded

  def download_new_image
    posts = RedditWallpaper.reddit.browse(subreddit)
    posts.map(&:url).each do |url|
      if download? url
        not_downloaded << url
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

  def download_image(url)
    return unless url
    # Append .jpg to ensure we are getting the image file from imgur
    url += ".jpg" unless url[/\.jpe?g\z/]

    open(path, 'wb') do |file|
      file << open(url, allow_redirections: :all).read
    end
    downloaded << url
  end
end
