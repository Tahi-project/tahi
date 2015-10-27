class Snapshot::FunderSerializer < Snapshot::BaseSerializer
  def initialize(funder)
    @funder = funder
  end

  def as_json
    snapshot_properties + snapshot_nested_questions
  end

  def snapshot_properties
    properties = []
    properties << snapshot_property("name", "text", @funder.name)
    properties << snapshot_property("grant_number", "text", @funder.grant_number)
    properties << snapshot_property("website", "text", @funder.website)
  end

  def snapshot_nested_questions
    funder_snapshot = []
    nested_questions = TahiStandardTasks::Funder.nested_questions.where(parent_id: nil).order('id')

    nested_questions.each do |question|
      question_serializer = Snapshot::NestedQuestionSerializer.new question, @funder
      funder_snapshot << question_serializer.as_json
    end

    funder_snapshot
  end
end
