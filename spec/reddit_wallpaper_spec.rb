require 'minitest/autorun'

require_relative '../lib/reddit_wallpaper'
require_relative 'support/reddit_stub'

describe 'RedditWallpaper' do
  let(:reddit_wallpaper) { RedditWallpaper.new(subreddit, "/dev/null") }
  let(:image_url)        { "http://i.imgur.com/Nhg3uHn.jpg" }
  let(:subreddit)        { "fancy-subreddit" }

  it 'downloads the latest image posts' do
    post = MiniTest::Mock.new
    post.expect :url, image_url

    RedditWallpaper.stub :reddit, Support::RedditStub.new([post]) do
      reddit_wallpaper.download_new_image
    end

    post.verify

    reddit_wallpaper.downloaded.must_include image_url
  end

  it 'loads posts from the specified subreddit' do
    reddit_stub = Support::RedditStub.new

    RedditWallpaper.stub :reddit, reddit_stub do
      reddit_wallpaper.download_new_image
    end

    reddit_stub.subreddit.must_equal subreddit
  end

  it 'does not download non-jpg files' do
    bad_url = "http://www.google.com"

    post = MiniTest::Mock.new
    post.expect :url, bad_url

    RedditWallpaper.stub :reddit, Support::RedditStub.new([post]) do
      reddit_wallpaper.download_new_image
    end

    post.verify

    reddit_wallpaper.downloaded.wont_include bad_url
  end

  it 'accepts imgur urls without an extension' do
    imgur_url = "http://imgur.com/Nhg3uHn"

    post = MiniTest::Mock.new
    post.expect :url, imgur_url

    RedditWallpaper.stub :reddit, Support::RedditStub.new([post]) do
      reddit_wallpaper.download_new_image
    end

    post.verify

    reddit_wallpaper.downloaded.must_include imgur_url + ".jpg"
  end

  it 'does not mind being redirected' do
    secure_url = "https://imgur.com/Nhg3uHn"

    post = MiniTest::Mock.new
    post.expect :url, secure_url

    RedditWallpaper.stub :reddit, Support::RedditStub.new([post]) do
      reddit_wallpaper.download_new_image
    end

    post.verify

    reddit_wallpaper.downloaded.must_include secure_url + ".jpg"
  end
end
