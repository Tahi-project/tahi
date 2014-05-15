class JournalSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo_url, :paper_types, :task_types
  has_many :reviewers, embed: :ids, include: true, root: :users
  has_many :manuscript_manager_templates, include: true

  def task_types
    Journal::VALID_TASK_TYPES
  end
end
