FactoryBot.define do
  factory :chatter do
    facebook_sender_id { Random.rand(1000...9000) }
    state { "initial" }
  end
end
