require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    TwilioClientStub.messages.clear
  end

  def valid_attributes
    { phone_number: '5551234567', name: 'Test' }
  end

  test 'saves user with valid attributes' do
    user = User.new(valid_attributes)
    assert(user.valid?)
  end

  test 'users do not save with invalid phone number' do
    with_letters = User.new(
      valid_attributes.merge(phone_number: 'abcdefgh')
    )
    blank = User.new(
      valid_attributes.merge(phone_number: '')
    )
    nil_phone_number = User.new(
      valid_attributes.merge(phone_number: nil)
    )
    too_few_characters = User.new(
      valid_attributes.merge(phone_number: 'abcdefgh')
    )
    assert_not with_letters.valid?
    assert_not blank.valid?
    assert_not nil_phone_number.valid?
    assert_not too_few_characters.valid?
  end

  test 'it removes extra characters from user phone number' do
    hyphens = User.new(
      valid_attributes.merge(phone_number: '555-123-4567')
    )
    assert hyphens.validate
    assert(hyphens.phone_number == '5551234567')

    parens = User.new(
      valid_attributes.merge(phone_number: '(555) 123-4567')
    )
    assert parens.validate
    assert(parens.phone_number == '5551234567')

    spaces = User.new(
      valid_attributes.merge(phone_number: '(555) 123-4567')
    )
    assert spaces.validate
    assert(spaces.phone_number == '5551234567')
  end

  test 'sends confirmation text after user creation' do
    user = User.new(valid_attributes)
    user.save!

    messages = TwilioClientStub.messages
    assert_equal(messages.length, 1)
    assert_equal(
      messages.first.body,
      "Thanks for signing up for Daily Dad Joke. "\
      "You should recieve your first message on the next weekday "\
      "specified during signup :)"
    )
    assert_equal(messages.first.to, user.formatted_phone_number)
  end
end
