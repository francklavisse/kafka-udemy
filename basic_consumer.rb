require 'ruby-kafka'

kafka = Kafka.new(["localhost:9092"])

kafka.each_message(topic: "first_topic") do |message|
  puts message.offset, message.key, message.value
end