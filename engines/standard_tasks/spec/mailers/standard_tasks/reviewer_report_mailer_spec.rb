require 'spec_helper'

describe StandardTasks::ReviewerReportMailer do
  describe ".notify_editor_email" do
    let(:paper) {
      FactoryGirl.create(:paper,
                         title: "Studies on the effects of saying Abracadabra",
                         short_title: "Magic")
    }

    let(:task) {
      FactoryGirl.create(:task,
                         title: "Reviewer Report",
                         role: 'reviewer',
                         type: "StandardTasks::ReviewerReportTask",
                         completed: true)
    }

    let(:editor) {
      double(:editor,
             full_name: 'Andi Plantenberg',
             email: "andi@example.com")
    }

    before do
      user = double(:user, last_name: 'Mazur')
      journal = double(:journal, name: 'PLOS Yeti')
      allow(paper).to receive(:creator).and_return(user)
      allow(paper).to receive(:editors).and_return([editor])
      allow(paper).to receive(:journal).and_return(journal)
      allow(task).to receive(:paper).and_return(paper)
    end

    let(:email) { described_class.notify_editor_email(task: task, recipient: editor) }

    it "sends to paper's editors" do
      expect(email.to).to eq(paper.editors.map(&:email))
    end

    it "contains link to the task" do
      expect(email.body).to match(%r{\/paper\/#{paper.id}\/tasks\/#{task.id}})
    end

    it "contains the paper title" do
      expect(email.body).to match(/Studies on the effects of saying Abracadabra/)
    end

    it "greets the editor by name" do
      expect(email.body).to match(/Hello Andi Plantenberg/)
    end
  end
end
