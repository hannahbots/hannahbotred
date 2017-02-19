require 'twitter_ebooks'

# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = 'd7rzNvnsHkzBz5VSVOEWCQEOx' # Your app consumer key
    self.consumer_secret = 'W52X0tUDCAzNmyFXV2W5bZ93FyveoV9EQFnvgD3nuF7m2QXIwf' # Your app consumer secret

    # Users to block instead of interacting with
    self.blacklist = ['tnietzschequote']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    scheduler.every '24h' do
      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      # pictweet("hi", "cuteselfie.jpg")
    end
  end

  def on_message(dm)
    # Reply to a DM
    reply(dm, "This bot is currently under construction.  Please check back later.")
  end

  def on_follow(user)
    # Follow a user back
    follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    reply(tweet, "This bot is currently under construction.  Please check back later.")
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    #reply(tweet, "nice tweet")
  end

  def on_favorite(user, tweet)
    # Follow user who just favorited bot's tweet
    follow(user.screen_name)
  end

  def on_retweet(tweet)
    # Follow user who just retweeted bot's tweet
    follow(tweet.user.screen_name)
  end
end

# Make a MyBot and attach it to an account
MyBot.new("TheRealJoshuaMB") do |bot|
  bot.access_token = "767897264752701440-gTy4va0qlcn5F389fFIABtkLGVVvhzB" # Token connecting the app to this account
  bot.access_token_secret = "EYNd1v4fML1OdngyXVtWNPK2Ex03f6O1Hekm22bStHLzj" # Secret connecting the app to this account
end
