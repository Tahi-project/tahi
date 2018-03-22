class InvitationIndexSerializer < AuthzSerializer
  self.root = :invitation

  attributes :id,
             :state,
             :title,
             :abstract,
             :email,
             :invitee_role,
             :created_at,
             :updated_at,
             :invitee_id,
             :information,
             :paper_type,
             :paper_short_doi,
             :journal_name

  has_one :task, embed: :id, polymorphic: true

  def title
    object.paper.title
  end

  def abstract
    object.paper.abstract
  end

  def paper_type
    object.paper.paper_type
  end

  def paper_short_doi
    object.paper.short_doi
  end

  def journal_name
    object.paper.journal.name
  end

  private

  # TODO: APERTA-12693 Stop overriding this
  def can_view?
    true
  end
end
