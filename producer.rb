require 'ruby-kafka'

kafka = Kafka.new(["localhost:9092"])

producer = kafka.async_producer(
    delivery_interval: 1, # deliver each second
    required_acks: :all, # already set to :all by default, but I wanted to write a config example
    max_buffer_size: 100, # max 100 messages 
    max_buffer_bytesize: 100_000 # max 10M of data
)

producer.produce("hello world", topic: "first_topic")
producer.produce("second message", topic: "first_topic")
producer.produce("byebye", topic: "first_topic")

producer.deliver_messages

at_exit { producer.shutdown }