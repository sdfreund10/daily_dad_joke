# frozen_string_literal: true

set :output, "/path/to/my/cron_log.log"

every 1.day, at: '4:30 am' do
  rake "message_sender:send_messages"
end
