class AnswerSerializer < AuthzSerializer
  include ReadySerializable
  attributes :id,
    :value,
    :annotation,
    :additional_data,
    :paper_id,
    :owner,
    :repetition_id

  has_one :card_content, embed: :id
  has_many :attachments, embed: :ids, include: true, root: :question_attachments

  def owner
    # Polymorphic assocations and STI do not play perfectly well with each other, as per
    # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#label-Polymorphic+Associations
    # Our Tasks are an STI table, so object.owner_type is going to be 'Task' for a Task subclass,
    # but Ember expects to have a specific subclass.
    owner_instance = object.owner
    { id: owner_instance.id, type: owner_instance.class.name.demodulize }
  end

  private

  # TODO: APERTA-12693 Stop overriding this
  def can_view?
    true
  end
end
