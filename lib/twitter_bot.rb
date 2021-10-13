require 'dotenv'
require 'twitter'
Dotenv.load


s_client = Twitter::Streaming::Client.new do |config|
	config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
	config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
	config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
	config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
end

r_client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
	config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
	config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
	config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
end

begin
	s_client.filter(track: "#bonjour_monde") do |tweet|
		puts "fav et folow de #{tweet.user.name}"
		r_client.favorite(tweet)
		r_client.follow(tweet.user)
	end
rescue Twitter::Error::TooManyRequests => error
	sleep error.rate_limit.reset_in + 1
	retry
end
