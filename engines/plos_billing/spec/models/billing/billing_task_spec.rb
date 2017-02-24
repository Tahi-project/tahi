require 'rails_helper'

module PlosBilling
  describe BillingTask do
    let(:paper) { FactoryGirl.create(:paper, :with_tasks) }
    let(:billing_task) do
      FactoryGirl.create(
        :billing_task,
        completed: true,
        paper: paper,
        phase: paper.phases.first
      )
    end

    describe '.restore_defaults' do
      it_behaves_like '<Task class>.restore_defaults update title to the default'
    end

    describe '.create' do
      it "creates it" do
        expect(billing_task).to_not be_nil
      end
    end

    describe '#active_model_serializer' do
      it 'has the proper serializer' do
        expect(billing_task.active_model_serializer).to eq PlosBilling::TaskSerializer
      end
    end
  end
end
