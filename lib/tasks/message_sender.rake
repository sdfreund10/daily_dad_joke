namespace :message_sender do
  desc "send a dad joke to users"
  task send_messages: :environment do
    user = User.find_by(name: "Steve", email: "sdfreund10@gmail.com", phone_number: "3173065649")
    raise "User does not exists" if user.nil?
    MessageSender.new([user.id]).call
  end
end
