require 'ruby-kafka'

kafka = Kafka.new(["localhost:9092"])

consumer = kafka.consumer(group_id: "group_1")

consumer.subscribe("first_topic")

trap("TERM") { consumer.stop }

consumer.each_message do |message|
  puts "------"
  puts "topic #{message.topic}, partition #{message.partition}"
  puts "off #{message.offset}, key #{message.key}"
  puts "value #{message.value}"
end