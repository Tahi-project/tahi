class FigureSerializer < AuthzSerializer
  attributes :id,
             :filename,
             :alt,
             :src,
             :status,
             :title,
             :caption,
             :detail_src,
             :preview_src,
             :created_at,
             :rank

  has_one :paper, embed: :id

  private

  # TODO: APERTA-12693 Stop overriding this
  def can_view?
    true
  end
end
