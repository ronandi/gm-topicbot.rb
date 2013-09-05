class Message
  attr_reader :sender, :message
  def initialize(msg)
    @sender = msg['name'] || ''
    @message = msg['text'] || ''
  end

  def is_topic_command?
    return message.split(' ').first == '!topic'
  end

  def topic_message
    return @sender + ' set topic to: ' + @message.split(' ').drop(1)
  end
end
