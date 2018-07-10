require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
end
