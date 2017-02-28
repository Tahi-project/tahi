##
# This model will store the answer given to a piece of
# CardContent.
#
class Answer < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :card_content
  belongs_to :owner, polymorphic: true
  belongs_to :paper

  has_many :attachments, -> { order('id ASC') }, dependent: :destroy, as: :owner, class_name: 'QuestionAttachment'

  validates :card_content, presence: true
  validates :owner, presence: true
  validates :paper, presence: true

  delegate :value_type, to: :card_content

  def children
    Answer.where(owner: owner, card_content: card_content.children)
  end

  def coerced_value
    CoerceAnswerValue.coerce(value, value_type)
  end

  # The primary reason an answer will need to find its task is for permission
  # checks in various controllers, since our R&P system normally speaks in
  # Tasks rather than at a more granular level
  def task
    if owner.is_a?(Task)
      owner
    elsif owner.respond_to?(:task)
      owner.task
    else
      fail NotImplementedError, <<-ERROR.strip_heredoc
        The owner (#{owner.inspect}) is not a Task and does not respond to
        #task. This is currently unsupported on #{self.class.name} and if you
        meant it to work you may need to update the implementation.
      ERROR
    end
  end
end
