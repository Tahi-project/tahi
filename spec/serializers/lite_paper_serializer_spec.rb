require 'rails_helper'

describe LitePaperSerializer do
  subject(:serializer) { LitePaperSerializer.new(paper, user: user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:paper) { FactoryGirl.create :paper }
  let(:serialized_content) { serializer.to_json }
  let(:deserialized_content) do
    JSON.parse(serialized_content, symbolize_names: true)
  end

  describe 'a paper' do
    it 'serializes successfully' do
      expect(deserialized_content[:lite_paper])
        .to match(hash_including(title: /Feature Recognition from 2D Hints in \
Extruded Solids/,
                                 publishing_state: 'unsubmitted',
                                 editable: true,
                                 active: true))
    end
  end

  describe 'a paper created by a user' do
    let(:paper) { FactoryGirl.create :paper, creator: user }
    it "includes the 'My Paper' old_role" do
      expect(deserialized_content[:lite_paper])
        .to match(hash_including(old_roles: include('My Paper')))
    end
  end

  describe 'for a paper with multiple old_roles' do
    let(:early_date) { Time.now.utc - 10 }
    let(:later_date) { Time.now.utc }
    let!(:paper_role1) do
      FactoryGirl.create(:paper_role, :editor, created_at: early_date,
                                               user: user, paper: paper)
    end
    let!(:paper_role2) do
      FactoryGirl.create(:paper_role, :admin, created_at: later_date,
                                              user: user, paper: paper)
    end

    it 'should use the latest old_role for the related_at_date' do
      expect(deserialized_content[:lite_paper])
        .to match(hash_including(related_at_date: later_date.as_json))
    end
  end
end
