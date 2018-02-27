# This serializes an author-safe version of manuscipt manager templates
class PaperTypeSerializer < AuthzSerializer
  attributes :id,
    :paper_type,
    :is_preprint_eligible,
    :task_names

  # Get titles of custom cards that are submission tasks
  # This is used by the client to see if the manuscript manaager template
  # has a Preprint Posting card, to decide whether to draw a preprint offer
  # overlay after the manuscript is first uploaded
  def task_names
    object.task_templates.select(&:required_for_submission).map(&:title)
  end

  private

  # TODO: APERTA-12693 Stop overriding this
  def can_view?
    true
  end
end
