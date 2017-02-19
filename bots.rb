require 'twitter_ebooks'


EBOOKS_CONSUMER_KEY="mLCB8wr19Rw4nTOYkwUEZ75uX"
EBOOKS_CONSUMER_SECRET="2TirvevxrpJULzxgsuF9Nddirmcom4WFvDbBJEsGJszUeAwvyk"
EBOOKS_OAUTH_TOKEN="828122795754344448-GR8Yc9zLZY1caPE12knfpcf5TvAytvG"
EBOOKS_OAUTH_TOKEN_SECRET="e8m9YS99eYBOirUtyPVBW7ykLj07ytEJEiUdtPtruzdvc"

#EBOOKS_CONSUMER_KEY="k1owUXtuHEc6KUuumcxA2dW6o"
#EBOOKS_CONSUMER_SECRET="ZuNw38nV9I1eIQWFLrqeeTRy9EWjHRl8VBGicgJ3ejDfiIcPsP"
#EBOOKS_OAUTH_TOKEN="828128175821582336-8cXyiS5xgo4uMa9QCeOSFu13dxNCeYY"
#EBOOKS_OAUTH_TOKEN_SECRET="oNo4j5SmaCFPnHB0zshTtuvGufGsB4NkTouWJBtkR7WCX"

#EBOOKS_CONSUMER_KEY="mOVNh9FsbBrEhNHORh78fYG0W"
#EBOOKS_CONSUMER_SECRET="FSyrgd2C5rwULRKk44udWKpx3Z1tpn3Sf0wE9Wa0qfnzJW29Hy"
#EBOOKS_OAUTH_TOKEN="828133626411884544-K36y7Q8enCl8QXKlBFO7wmIimEcwTcn"
#EBOOKS_OAUTH_TOKEN_SECRET="XVKqQ8KJpRG7eSrY3qafbzBdK6txeZxAaQXB1xJBrUCos"


# Information about a particular Twitter user we know
class UserInfo
  attr_reader :username

  # @return [Integer] how many times we can pester this user unprompted
  attr_accessor :pesters_left

  # @param username [String]
  def initialize(username)
    @username = username
    @pesters_left = 1
  end
end

class CloneBot < Ebooks::Bot
  attr_accessor :original, :model, :model_path

  def configure
    # Configuration for all CloneBots
    self.consumer_key = EBOOKS_CONSUMER_KEY
    self.consumer_secret = EBOOKS_CONSUMER_SECRET
    self.blacklist = ['kylelehk', 'friedrichsays', 'Sudieofna', 'tnietzschequote', 'NerdsOnPeriod', 'FSR', 'BafflingQuotes']
    self.delay_range = 10..30
    @userinfo = {}
  end

  def top100; @top100 ||= model.keywords.take(100); end
  def top20;  @top20  ||= model.keywords.take(20); end

  def on_startup
    load_model!

    scheduler.cron '23 * * * *' do
      tweet(model.make_statement)
    end

    scheduler.cron '24 * * * *' do
      tweet(model.make_statement)
    end

    scheduler.cron '25 * * * *' do
      tweet(model.make_statement)
    end

    scheduler.cron '26 * * * *' do
      tweet(model.make_statement)
    end

    scheduler.cron '27 * * * *' do
      tweet(model.make_statement)
    end

    scheduler.cron '28 * * * *' do
      tweet(model.make_statement)
    end


    scheduler.cron '29 * * * *' do
      tweet(model.make_statement)
    end




  end

  def on_message(dm)
      reply(dm, model.make_response(dm.text))
  end

  def on_mention(tweet)
    # Become more inclined to pester a user when they talk to us
    userinfo(tweet.user.screen_name).pesters_left += 1

    delay do
      reply(tweet, model.make_response(meta(tweet).mentionless, meta(tweet).limit))
    end
  end

  def on_timeline(tweet)
    return if tweet.retweeted_status?
    return unless can_pester?(tweet.user.screen_name)

    tokens = Ebooks::NLP.tokenize(tweet.text)

    #interesting = tokens.find { |t| top100.include?(t.downcase) }
    very_interesting = tokens.find_all { |t| top20.include?(t.downcase) }.length > 2

    delay do
      if very_interesting
        favorite(tweet)
        retweet(tweet) if rand < 0.1
        if rand < 0.01
          userinfo(tweet.user.screen_name).pesters_left -= 1
          reply(tweet, model.make_response(meta(tweet).mentionless, meta(tweet).limit))
        end
      elsif
        favorite(tweet)
        if rand < 0.001
          userinfo(tweet.user.screen_name).pesters_left -= 1
          reply(tweet, model.make_response(meta(tweet).mentionless, meta(tweet).limit))
        end
      end
    end
  end

  # Find information we've collected about a user
  # @param username [String]
  # @return [Ebooks::UserInfo]
  def userinfo(username)
    @userinfo[username] ||= UserInfo.new(username)
  end

  # Check if we're allowed to send unprompted tweets to a user
  # @param username [String]
  # @return [Boolean]
  def can_pester?(username)
    userinfo(username).pesters_left > 0
  end

  # Only follow our original user or people who are following our original user
  # @param user [Twitter::User]
  def can_follow?(username)
    @original.nil? || username.casecmp(@original) == 0 || twitter.friendship?(username, @original)
  end

  def favorite(tweet)
    if can_follow?(tweet.user.screen_name)
      super(tweet)
    else
      delay do
        delay do
          super(tweet)
        end
      end
      #log "Unfollowing @#{tweet.user.screen_name}"
      #twitter.unfollow(tweet.user.screen_name)
    end
  end


  def on_follow(user)
    if can_follow?(user.screen_name)
      follow(user.screen_name)
    else
      delay do
        follow(user.screen_name)
      end
      log "Following @#{user.screen_name}"
    end
  end

  private
  def load_model!
    return if @model

    @model_path ||= "model/#{original}.model"


    log "Loading model #{model_path}"
    @model = Ebooks::Model.load(model_path)


  end
end

MODEL_VAR = 1


BOT_ORIGINAL = "HananAHHHH"

CloneBot.new("realHananAHHHH") do |bot|
  bot.access_token = EBOOKS_OAUTH_TOKEN
  bot.access_token_secret = EBOOKS_OAUTH_TOKEN_SECRET

  bot.original = BOT_ORIGINAL
end
