require 'ruby-kafka'

kafka = Kafka.new(["localhost:9092"])

consumer = kafka.consumer(
    group_id: "twitter_ruby",
    offset_commit_interval: 2,
    offset_commit_threshold: 5
)

consumer.subscribe(
    "twitter_tweets",
    start_from_beginning: true    
)

trap("TERM") { consumer.stop }

if ENV["BATCH"]
    consumer.each_batch(min_bytes: 1024, max_wait_time: 1) do |batch|    
        puts "------"
        puts "Batch: #{batch.topic}/#{batch.partition}"
        puts batch
        batch.messages.each do |message|
            puts message.value
        end
    end
else
    consumer.each_message(min_bytes: 1024, max_wait_time: 1) do |message|
        puts "------"
        puts "value #{message.value}"
    end
end