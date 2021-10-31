require 'ruby-kafka'
require 'twitter'
require 'dotenv/load'

client = Twitter::Streaming::Client.new do |config|
    config.consumer_key        = ENV['CONSUMER_KEY']
    config.consumer_secret     = ENV['CONSUMER_SECRET']
    config.access_token        = ENV['TOKEN']
    config.access_token_secret = ENV['SECRET']
end

kafka = Kafka.new(["localhost:9092"])

producer = kafka.async_producer(
    delivery_interval: 1, # deliver each second
    required_acks: :all, # already set to :all by default, but I wanted to write a config example
    max_buffer_size: 100, # max 100 messages 
    max_buffer_bytesize: 100_000, # max 10M of data
    compression_codec: :lz4,
    compression_threshold: 5,
)

topics = ["bitcoin", "eth", "btc"]
client.filter(track: topics.join(",")) do |object|
    if object.is_a?(Twitter::Tweet)
        puts object.text 
        producer.produce(object.text, topic: "twitter_tweets")
    end
end