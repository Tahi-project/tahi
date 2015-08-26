class Invitation::Updated::EventStream::NotifyInvitee < EventStreamSubscriber

  def channel
    record.invitee
  end

  def payload
    InvitationIndexSerializer.new(record).to_json
  end

end
