require 'rails_helper'

describe SalesforceServices::ObjectTranslations do
  let(:user) { FactoryGirl.create(:user) }
  let(:paper) { FactoryGirl.create(:paper) }
  let(:mt) do
    SalesforceServices::ObjectTranslations::ManuscriptTranslator.new(user_id: user.id, paper: paper)
  end

  describe "ManuscriptTranslator#paper_to_manuscript_hash" do
    it "return a hash" do
      expect(mt.paper_to_manuscript_hash.class).to eq Hash
    end
  end

  describe "BillingTranslator#paper_to_billing_hash" do
    it "return a hash" do
      paper = make_paper

      bt    = SalesforceServices::ObjectTranslations::BillingTranslator.new(paper: paper)
      data  = bt.paper_to_billing_hash

      expect(data.class).to                          eq Hash
      expect(data['SuppliedEmail']).to               eq('pfa@pfa.com' )
      expect(data['Exclude_from_EM__c']).to          eq(true)
      expect(data['Journal_Department__c']).to       eq(paper.journal.name)
      expect(data['Subject']).to                     eq("doi_missing_for_id_#{paper.id}") # will prob change when doi is in RC?
      expect(data['Origin']).to                      eq('PFA Request')
      expect(data['Description']).to                 match('lou prima')
      expect(data['Description']).to                 match('has applied')
      expect(data['Description']).to                 match("doi_missing_for_id_#{paper.id}") # will prob change when doi is in RC?
      expect(data['PFA_Question_1__c']).to           eq ('Yes')
      expect(data['PFA_Question_1a__c']).to          eq ('foo')
      expect(data['PFA_Question_1b__c']).to          eq (100.00)
      expect(data['PFA_Question_2__c']).to           eq ('Yes')
      expect(data['PFA_Question_2a__c']).to          eq ('foo')
      expect(data['PFA_Question_2b__c']).to          eq (100.00)
      expect(data['PFA_Question_3__c']).to           eq ('Yes')
      expect(data['PFA_Question_3a__c']).to          eq (100.00)
      expect(data['PFA_Question_4__c']).to           eq ('Yes')
      expect(data['PFA_Question_4a__c']).to          eq (100.00)
      expect(data['PFA_Able_to_Pay_R__c']).to        eq (100.00)
      expect(data['PFA_Additional_Comments__c']).to  eq ('my comments')
      expect(data['PFA_Supporting_Docs__c']).to      eq (true) #indirectly tests private method boolean_from_text_answer_for
    end
  end

  def make_paper
    journal = FactoryGirl.create(:journal, { name: 'journal name' })
    paper = FactoryGirl.create :paper_with_task, {
      creator: FactoryGirl.create(:user, { first_name: 'lou', last_name: 'prima', email: 'pfa@pfa.com' }),
      journal: journal,
      short_title: "my title",
      task_params: { title: "Billing", type: "PlosBilling::BillingTask", role: "author" }
    }
    make_questions paper
    paper
  end

  def make_questions(paper)
      add_question(paper, 'pfa_question_1',          'Yes')
      add_question(paper, 'pfa_question_1a',         'foo')
      add_question(paper, 'pfa_question_1b',         '100')
      add_question(paper, 'pfa_question_2',          'Yes')
      add_question(paper, 'pfa_question_2a',         'foo')
      add_question(paper, 'pfa_question_2b',         '100')
      add_question(paper, 'pfa_question_3',          'Yes')
      add_question(paper, 'pfa_question_3a',         '100')
      add_question(paper, 'pfa_question_4',          'Yes')
      add_question(paper, 'pfa_question_4a',         '100')
      add_question(paper, 'pfa_amount_to_pay',       '100')
      add_question(paper, 'pfa_additional_comments', 'my comments')
      add_question(paper, 'pfa_supporting_docs',     'Yes')
  end

  def add_question(paper, ident, answer)
    q = FactoryGirl.create :question, ident: "plos_billing.#{ident}", answer: answer, task: paper.billing_card
  end
end
