# frozend_string_literal: true
require 'spec_helper'

describe Pinfirmable do
  it 'calls emailer after create' do
    expect(PinfirmableMailer)
    .to receive(:pin_email).with(an_instance_of(User))
    .and_return( double('PinfirmableMailer', deliver: true))

    u = User.new(
              email: 'test@example.com',
              password: 'password'
    )
    u.save
  end

  it "doesn't call emailer if skip_pinfirmation! is called" do
    expect(PinfirmableMailer).
      not_to receive(:pin_email).with(an_instance_of(User))
    u = User.new(
      email: 'test@example.com',
      password: 'password'
    )
    u.skip_pinfirmation!
    u.save
  end
end
