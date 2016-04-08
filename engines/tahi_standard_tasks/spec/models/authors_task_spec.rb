require 'rails_helper'

describe TahiStandardTasks::AuthorsTask do
  describe "#validate_authors" do
    let!(:valid_author) do
      author = FactoryGirl.create(:author, paper: task.paper)
      question = Author.contributions_question
      contribution = question.children.first
      q = author.find_or_build_answer_for(nested_question: contribution)
      q.value = true
      q.save!
      author
    end

    let(:task) { FactoryGirl.create(:authors_task) }

    it "hooks up authors via AuthorListItems" do
      expect(task.reload.authors).to include(valid_author)
    end

    it "validates individual authors" do
      invalid_author = FactoryGirl.create(
        :author,
        email: nil,
        paper: task.paper)

      task.update(completed: true)

      expect(task.reload.valid?).to be(false)
      expect(task.errors[:authors][invalid_author.id].messages).to be_present
    end

    it "validates individual authors" do
      task.update(completed: true)
      expect(task.reload.valid?).to be(true)
    end
  end
end
