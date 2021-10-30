require 'ruby-kafka'

kafka = Kafka.new(["localhost:9092"])

consumer = kafka.consumer(
    group_id: "group_a",
    offset_commit_interval: 2, # commit each 2 seconds
    offset_commit_threshold: 5, # commit offset each 5 messages
)

consumer.subscribe(
    "first_topic",
    start_from_beginning: true    
)

trap("TERM") { consumer.stop }

consumer.each_message do |message|
  puts "------"
  puts "topic #{message.topic}, partition #{message.partition}"
  puts "off #{message.offset}, key #{message.key}"
  puts "value #{message.value}"
end