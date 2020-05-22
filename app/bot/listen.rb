require "facebook/messenger"

Facebook::Messenger::Bot.on :message do |message|
  Chats::HandleMessage.call(message: message)
end

Facebook::Messenger::Bot.on :postback do |postback|
  Chats::HandlePostback.call(postback: postback)
end
