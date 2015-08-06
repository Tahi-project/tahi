require 'rails_helper'

describe VersionedText do
  let(:paper) { FactoryGirl.create :paper }

  describe "#new_major_version!" do
    it "creates a new major version while retaining the old" do
      old_version = paper.latest_version
      paper.latest_version.new_major_version!
      expect(old_version.major_version).to eq(0)
      expect(old_version.minor_version).to eq(0)
      expect(VersionedText.where(paper: paper, major_version: 1, minor_version: 0).count).to eq(1)
    end
  end

  describe "#new_minor_version!" do
    it "creates a new minor version while retaining the old" do
      old_version = paper.latest_version
      paper.latest_version.new_minor_version!
      expect(old_version.major_version).to eq(0)
      expect(old_version.minor_version).to eq(0)
      expect(VersionedText.where(paper: paper, major_version: 0, minor_version: 1).count).to eq(1)
    end
  end

  describe "#create" do
    it "should not allow creating multiple versions with the same number" do
      FactoryGirl.create(:versioned_text, paper_id: 1, major_version: 1, minor_version: 0)
      expect do
        FactoryGirl.create(:versioned_text, paper_id: 1, major_version: 1, minor_version: 0)
      end.to raise_exception(ActiveRecord::RecordNotUnique)
    end
  end

  it "should prevent writes on an old version" do
    old_version = paper.latest_version
    paper.latest_version.new_minor_version!
    expect { old_version.update!(text: "foo") }.to raise_exception(ActiveRecord::ReadOnlyRecord)
  end

  it "should prevent writes if paper is not editable" do
    paper.update!(editable: false)
    expect { paper.latest_version.update!(text: "foo") }.to raise_exception(ActiveRecord::ReadOnlyRecord)
  end
end
