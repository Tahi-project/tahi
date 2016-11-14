# encoding: utf-8

class BillingLogUploader < CarrierWave::Uploader::Base
  storage Rails.application.config.carrierwave_storage

  after :store, :log_file_location

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def log_file_location(_)
    model.logger.info "Saved Billing log to #{@file.path}"
  end
end
