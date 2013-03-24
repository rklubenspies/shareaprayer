require 'spec_helper'

describe RequestDecorator do
  describe '#author' do
    context 'when the request was posted anonymously' do
      let (:request) { FactoryGirl.create(:request, anonymous: true).decorate }

      it 'should show the display name as Anonymous' do
        request.author.should == "Anonymous"
      end
    end

    context 'when the request was not posted anonymously' do
      let (:request) { FactoryGirl.create(:request).decorate }

      it 'should should the users real name' do
        request.author.should == request.user.name
      end
    end
  end

  describe '#created_at' do
    pending
  end

  describe '#prayers' do
    pending
  end

  describe '#profile_pic' do
    pending
  end

  describe '#short' do
    pending
  end

  describe '#long' do
    pending
  end
end