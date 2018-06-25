# stub out twilio client to avoid sending messages in tests

class TwilioClientStub
  Message = Struct.new(:from, :to, :body)

  cattr_accessor :messages
  self.messages = []

  def initialize(_account_sid, _auth_token)
  end

  def messages
    self
  end

  def create(from:, to:, body:)
    self.class.messages << Message.new(from, to, body)
  end
end

# silent warning about redefining constant
begin
  old_stderr = $stderr
  $stderr = StringIO.new
  Twilio::REST::Client = TwilioClientStub
ensure
  $stderr = old_stderr
end
