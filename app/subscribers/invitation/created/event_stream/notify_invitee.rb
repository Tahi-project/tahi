class Invitation::Created::EventStream::NotifyInvitee < EventStreamSubscriber

  def channel
    private_channel_for(record.invitee)
  end

  def payload
    InvitationIndexSerializer.new(record).as_json
  end

end
