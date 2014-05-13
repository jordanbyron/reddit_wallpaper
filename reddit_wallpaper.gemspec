Gem::Specification.new do |s|
  s.name        = "reddit_wallpaper"
  s.version     = File.read('VERSION').strip
  s.authors     = ["Emad Elsaid", "Jordan Byron"]
  s.email       = %w[blazeeboy@gmail.com jordan.byron@gmail.com]
  s.homepage    = "https://github.com/jordanbyron/reddit_wallpaper"
  s.summary     = "Auto-changing wallpaper from reddit / imgur images"
  s.description = "Download the latest images from your favorite subreddit " + 
                  "and set them as your desktop background"
  s.license     = "MIT"
  s.executables = 'reddit_wallpaper'

  s.required_ruby_version = '>= 1.9.3'
  s.files                 = Dir["{lib,bin}/**/*"] + %w{README.md LICENSE}
  s.test_files            = Dir["spec/**/*"]

  s.add_dependency "ruby_reddit_api",       "~> 0.2"
  s.add_dependency "open_uri_redirections", "~> 0.1"

  s.add_development_dependency "minitest", "~> 5.3"
end
