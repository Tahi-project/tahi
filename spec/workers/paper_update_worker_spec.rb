require 'rails_helper'

describe PaperUpdateWorker do
  subject(:worker) { PaperUpdateWorker.new }
  let(:paper) { FactoryGirl.create :paper, processing: true }
  let(:stubbed_url) { "http://s3_url_example" }
  let(:ihat_job_params) { { state: 'completed', options: { metadata: { paper_id: paper.id } }, outputs: [{ file_type: 'epub', url: stubbed_url }] } }

  describe "#perform" do
    let(:turtles_fixture) { File.open(Rails.root.join('spec', 'fixtures', 'turtles.epub'), 'rb').read }

    before do
      VCR.turn_off!
      stub_request(:get, stubbed_url).to_return(body: turtles_fixture)
    end

    after do
      VCR.turn_on!
      expect(WebMock).to have_requested(:get, stubbed_url)
    end

    it "requests attribute extraction" do
      expect_any_instance_of(PaperAttributesExtractor).to receive(:sync!)
      worker.perform(ihat_job_params)
    end

    it "sets the paper's status to 'done'" do
      expect do
        worker.perform(ihat_job_params)
      end.to change { paper.reload.processing }.from(true).to(false)
    end
  end

  describe "#perform on an error" do
    it "raises an exception when an error occurs" do
      ihat_job_params[:outputs] = nil
      expect { worker.perform(ihat_job_params) }.to raise_error(NoMethodError)
      paper.update!(processing: false)
      expect(paper.processing).to eq(false)
    end
  end

  describe "retries" do
    it "does not retry" do
      expect(worker.sidekiq_options_hash["retry"]).to be(false)
    end
  end
end
