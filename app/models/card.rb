# Card is a container for CardContents
class Card < ActiveRecord::Base
  include EventStream::Notifiable
  acts_as_paranoid

  belongs_to :journal, inverse_of: :cards
  has_many :card_versions, inverse_of: :card, dependent: :destroy
  validates :name, presence: { message: "Please give your card a name." }
  validates :name, uniqueness: {
    scope: :journal,
    message: "That card name is taken. Please give your card a new name."
  }

  def content_for_version(version_no)
    content_root_for_version(version_no).self_and_descendants
  end

  def content_root_for_version(version_no)
    card_versions.find_by!(version: version_no).card_content
  end

  def latest_card_version
    card_versions.find_by!(version: latest_version)
  end

  def self.create_new(attrs)
    Card.transaction do
      card = Card.create!(attrs)
      root = CardContent.create!(card: card)
      CardVersion.create!(version: 1, card: card, card_content: root)
      card
    end
  end

  def self.lookup_card(owner_type)
    return if owner_type.to_s =~ /AdHocTask$/
    name = case owner_type.to_s
           when /Task$/
             owner_type.to_s
           when "Author"
             'Author'
           when "GroupAuthor"
             'GroupAuthor'
           when "Funder"
             'TahiStandardTasks::Funder'
           when "ReviewerRecommendation"
             'TahiStandardTasks::ReviewerRecommendation'
           when "ReviewerReport"
             'ReviewerReport'
           else
             raise "Don't know how to lookup owner_type: #{owner_type}"
           end
    Card.find_by!(name: name)
  end
end
