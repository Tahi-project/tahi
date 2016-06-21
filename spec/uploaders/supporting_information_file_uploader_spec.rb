require 'rails_helper'

describe SupportingInformationFileUploader do
  around do |example|
    AttachmentUploader.storage :file
    example.run
    AttachmentUploader.storage Rails.application.config.carrierwave_storage
  end

  describe '#store_dir' do
    let(:uploader) { described_class.new(model, :attachment) }

    context 'when the model has a cached s3_dir' do
      let(:model) { double('attachment_model', s3_dir: 'some/cached/path') }

      it 'returns the cached s3_dir' do
        expect(uploader.store_dir).to eq('some/cached/path')
      end
    end

    context 'when the model does not respond_to :s3_dir' do
      let(:model) { double('attachment_model', id: 99) }

      it 'returns a computed value' do
        expect(uploader.store_dir).to eq \
          "uploads/attachments/99/supporting_information_file/attachment/99"
      end
    end

    context 'when the model responds to :s3_dir, but has no s3_dir value' do
      let(:model) { double('attachment_model', id: 99, s3_dir: nil) }

      it 'returns a computed value' do
        expect(uploader.store_dir).to eq \
          "uploads/attachments/99/supporting_information_file/attachment/99"
      end
    end
  end
end
