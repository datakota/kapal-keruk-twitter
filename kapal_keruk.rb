require 'tweetstream'
require 'mysql2'


client = Mysql2::Client.new(
	host: "localhost", 
	username: "", 
	password: "", 
	database: "",
	socket: "/var/run/mysqld/mysqld.sock",
	encoding: "utf8"
)

TweetStream.configure do |config|
	config.consumer_key       = ''
	config.consumer_secret    = ''
	config.oauth_token        = ''
	config.oauth_token_secret = ''
	config.auth_method        = :oauth
end

TweetStream::Client.new.track('keyword', 'to', 'track') do |status|
	data = status.to_h

	id = data[:id_str]
	longitude = data[:coordinates][:coordinates][0]
	latitude = data[:coordinates][:coordinates][1]
	type = data[:coordinates][:type]
	text = data[:text]
	source = client.escape(data[:source])
	screen_name = data[:user][:screen_name]
	created_at = DateTime.parse(data[:created_at])
	created_at_formatted = created_at.strftime "%Y-%m-%d %H:%M:%S"

	# store into database
	query = "INSERT INTO traffic_jam(id_tweet, longitude, latitude, type, text, source, screen_name, created_at) VALUES('#{id}', '#{longitude}', '#{latitude}', '#{type}', '#{text}', '#{source}', '#{screen_name}', '#{created_at_formatted}')"
	client.query(query)
end