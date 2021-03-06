# Copyright (c) 2018 Public Library of Science

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

require 'rails_helper'

describe "ManuscriptManagerTemplateForm" do
  let(:journal) { FactoryGirl.create(:journal) }
  let(:valid_form) { ManuscriptManagerTemplateForm.new(valid_params) }
  let(:template) { FactoryGirl.create(:manuscript_manager_template) }

  context "Creating a ManuscriptManagerTemplate" do
    it "Creates a ManuscriptManagerTemplate" do
      valid_form.create!
      last_template = ManuscriptManagerTemplate.last
      expect(last_template.paper_type).to eql("Research 2222")
      expect(last_template.journal).to eql(journal)
    end

    it "Creates phases for the ManuscriptManagerTemplate" do
      valid_form.create!
      last_template = ManuscriptManagerTemplate.last
      expect(last_template.phase_templates.size).to eql(3)
      expect(last_template.phase_templates[0].name).to eql("Phase 1")
      expect(last_template.phase_templates[0].position).to eql(1)
      expect(last_template.phase_templates[1].name).to eql("Phase 2")
      expect(last_template.phase_templates[1].position).to eql(2)
      expect(last_template.phase_templates[2].name).to eql("Phase 3")
      expect(last_template.phase_templates[2].position).to eql(3)
    end

    it "Create task_templates for each phase" do
      valid_form.create!
      last_template = ManuscriptManagerTemplate.last
      task_templates = last_template.phase_templates.first.task_templates

      expect(task_templates.size).to eql(2)
      expect(task_templates[0].title).to eql("Authors")
      expect(task_templates[0].position).to eql(1)
      expect(task_templates[1].title).to eql("Team")
      expect(task_templates[1].position).to eql(2)
    end
  end

  context "Updating a ManuscriptManagerTemplate" do

    it "Updates the ManuscriptManagerTemplate" do
      form = ManuscriptManagerTemplateForm.new({"paper_type"=>"Celeborn"})
      form.update! template
      expect(template.reload.paper_type).to eql("Celeborn")
    end

    it "Adds a Phase" do

      params = {"paper_type"=>"Research 2222",
              "phase_templates"=>[{"name"=>"Phase 1", "position"=>1}]}

      form = ManuscriptManagerTemplateForm.new(params)
      form.update! template

      expect(template.reload.phase_templates.size).to eql(1)
      expect(template.phase_templates[0].name).to eql("Phase 1")
    end

    it "Removes a Phase" do
      template.phase_templates << FactoryGirl.create(:phase_template)
      template.phase_templates << FactoryGirl.create(:phase_template)

      params = {"paper_type"=>"Research 2222",
              "phase_templates"=>[{"name"=>"Phase 1", "position"=>1}]}

      expect {
        form = ManuscriptManagerTemplateForm.new(params)
        form.update! template
      }.to change { PhaseTemplate.count }.by(-1)
    end
  end

  def valid_params
    {"paper_type"=>"Research 2222", "journal_id"=>journal.id,
      "phase_templates"=>[{"name"=>"Phase 1", "position"=>1,
        "task_templates"=>[
          {"title"=>"Authors", "journal_task_type_id"=>"86", "position"=>1},
          {"title"=>"Team", "journal_task_type_id"=>"111", "position"=>2}
        ]},
      {"name"=>"Phase 2", "position"=>2},
      {"name"=>"Phase 3", "position"=>3}]}
  end
end
