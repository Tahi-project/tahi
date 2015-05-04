class InvitationSerializer < ActiveModel::Serializer
  attributes :id,
             :state,
             :title,
             :abstract,
             :email,
             :invitation_type,
             :created_at,
             :updated_at

  has_one :invitee, serializer: UserSerializer, embed: :id, root: :users, include: true

  def title
    object.paper.title
  end

  def abstract
    object.paper.abstract
  end

  def invitation_type
    object.task.invitee_role.capitalize
  end
end
