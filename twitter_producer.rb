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
    compression_codec: :lz4,
    compression_threshold: 5,
    delivery_interval: 1,
    delivery_threshold: 10,
    max_buffer_bytesize: 1_000,
    max_buffer_size: 100,
    required_acks: :all,
)

topics = ["bitcoin", "eth", "btc"]
client.filter(track: topics.join(",")) do |object|
    if object.is_a?(Twitter::Tweet)
        producer.produce(object.text, topic: "twitter_tweets")
    end
end