# Copyright (c) 2018 Public Library of Science

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

require "rails_helper"

describe TahiPusher::Channel do

  let(:channel_name) { "private-paper@4" }
  let(:channel) { TahiPusher::Channel.new(channel_name: channel_name) }

  describe "#authenticate" do
    let(:socket_id) { "999" }

    it "with the correct channel" do
      expect(Pusher).to receive(:[]).with(channel_name).and_call_original
      channel.authenticate(socket_id: socket_id)
    end

    it "with the correct socket" do
      expect_any_instance_of(Pusher::Channel).to receive(:authenticate).with(socket_id)
      channel.authenticate(socket_id: socket_id)
    end
  end

  describe "#push" do
    let(:event_name) { "created" }
    let(:payload) { { somejson: true } }

    it "sends payload to pusher channel" do
      expect(Pusher).to receive(:trigger).with(channel_name, event_name, payload, {})
      channel.push(event_name: event_name, payload: payload)
    end
  end

  describe "authorized?" do
    let(:user) { double(:user, id: 1) }

    context "when target is the system channel" do
      let(:channel) { TahiPusher::Channel.new(channel_name: "system") }

      it "returns true" do
        expect(channel.authorized?(user: user)).to eq(true)
      end
    end

    context "when target is active record object" do
      let(:channel) { TahiPusher::Channel.new(channel_name: "private-paper@4") }

      context "when the target exists" do
        let!(:paper) { create(:paper, id: 4) }
        context "when user has access to the target" do
          it "returns true" do
            allow(user).to receive(:can?).and_return(true)
            expect(channel.authorized?(user: user)).to eq(true)
          end
        end

        context "when user does not have access to the target" do
          it "returns false" do
            allow(user).to receive(:can?).and_return(false)
            expect(channel.authorized?(user: user)).to eq(false)
          end
        end
      end

      context "when the target does not exist" do
        it "returns false" do
          expect(channel.authorized?(user: user)).to eq(false)
        end
      end
    end
  end
end
