require 'ruby-kafka'

kafka = Kafka.new(["localhost:9092"], client_id: "my_app")
producer = kafka.async_producer(delivery_interval: 1)

producer.produce("hello world", topic: "first_topic")
producer.produce("second message", topic: "first_topic")
producer.produce("byebye", topic: "first_topic")

producer.deliver_messages

producer.shutdown