module Support
  class RedditStub
    def initialize(posts = [])
      @posts = posts
    end

    attr_reader   :subreddit
    attr_accessor :posts

    def browse(subreddit)
      @subreddit = subreddit
      posts
    end
  end
end
