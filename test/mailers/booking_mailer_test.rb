require 'test_helper'

class BookingMailerTest < ActionMailer::TestCase
  test "match_day_is_coming" do
    mail = BookingMailer.match_day_is_coming
    assert_equal "Match day is coming", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
