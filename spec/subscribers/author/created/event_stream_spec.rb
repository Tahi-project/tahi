require 'rails_helper'

describe Author::Created::EventStream do
  include EventStreamMatchers

  let(:pusher_channel) { mock_delayed_class(TahiPusher::Channel)}
  let(:paper) { FactoryGirl.create(:paper) }
  let(:author) { FactoryGirl.create(:author, paper: paper) }

  it "serializes author down the paper channel on creation" do
    expect(pusher_channel).to receive_push(payload: hash_including(:author), down: 'paper', on: 'created')
    described_class.call("tahi:author:created", { action: "created", record: author })
  end

end
