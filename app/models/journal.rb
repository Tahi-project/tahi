class Journal < ActiveRecord::Base
  has_many :papers, inverse_of: :journal
  has_many :roles, inverse_of: :journal
  has_many :user_roles, through: :roles
  has_many :users, through: :user_roles
  has_many :manuscript_manager_templates, dependent: :destroy
  has_many :journal_task_types, inverse_of: :journal, dependent: :destroy

  validates :name, presence: { message: 'Please include a journal name' }
  validates :doi_journal_prefix, uniqueness: {
    scope: [:doi_publisher_prefix],
    if: proc { |journal|
      journal.doi_journal_prefix.present? && journal.doi_publisher_prefix.present?
    }
  }
  validate :has_valid_doi_information?

  after_create :setup_defaults
  before_destroy :destroy_roles

  mount_uploader :logo,       LogoUploader
  mount_uploader :epub_cover, EpubCoverUploader

  def admins
    users.merge(Role.admins)
  end

  def editors
    users.merge(Role.editors)
  end

  def reviewers
    users.merge(Role.reviewers)
  end

  def logo_url
    logo.thumbnail.url if logo
  end

  def epub_cover_file_name
    return nil unless epub_cover.file

    if Rails.application.config.carrierwave_storage == :fog
      URI(epub_cover.file.url).path.split('/').last
    else
      epub_cover.file.filename
    end
  end

  def epub_cover_url
    epub_cover.url if epub_cover
  end

  def paper_types
    self.manuscript_manager_templates.pluck(:paper_type)
  end

  def valid_roles
    PaperRole::ALL_ROLES | roles.map(&:name)
  end

  private

  def has_valid_doi_information?
    ds = DoiService.new(journal: self)
    return unless ds.journal_has_doi_prefixes?
    return if ds.journal_doi_info_valid?
    errors.add(:doi, "The DOI you specified is not valid.")
  end

  def setup_defaults
    # TODO: remove these from being a callback (when we aren't using rails_admin)
    JournalServices::CreateDefaultRoles.call(self)
    JournalServices::CreateDefaultTaskTypes.call(self)
    JournalServices::CreateDefaultManuscriptManagerTemplates.call(self)
  end

  def destroy_roles
    # roles that are marked as 'required' are prevented from being destroyed, so you cannot use
    # a dependent_destroy on the AR relationship.
    self.mark_for_destruction
    roles.destroy_all
  end
end
