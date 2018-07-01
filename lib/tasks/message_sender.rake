namespace :message_sender do
  desc "send a dad joke to users"
  task send_messages: :environment do
    day = Date::DAYNAMES[Date.today.wday].downcase
    users = User.where(day => true).ids
    return "No users today" if users.empty?
    MessageSender.new(users).call
  end
end
