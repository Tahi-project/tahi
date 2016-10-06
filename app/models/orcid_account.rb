class OrcidAccount < ActiveRecord::Base
  include EventStream::Notifiable

  belongs_to :user
  attr_accessor :oauth_authorize_url

  class APIError < StandardError; end

  def update_orcid_profile!
    api_profile_url = "https://#{ENV['ORCID_API_HOST']}/" \
      + "v#{ENV['ORCID_API_VERSION']}/" \
      + "#{identifier}/orcid-profile"

    response = RestClient.get(api_profile_url,
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => "application/orcid+xml")

    update_attributes(
      profile_xml: response.body,
      profile_xml_updated_at: DateTime.now.utc
    )
  rescue RestClient::ExceptionWithResponse => ex
    raise OrcidAccount::APIError, ex.to_s
  end

  def profile_url
    return unless identifier
    'https://' + ENV['ORCID_SITE_HOST'] + '/' + identifier
  end

  def access_token_valid
    return unless expires_at
    (expires_at > DateTime.now.utc) && access_token
  end

  def status
    return :unauthenticated unless access_token
    return :authenticated if access_token_valid
    :access_token_expired
  end

  def reset!
    exceptions = %w(id user_id created_at updated_at)
    attribute_names
      .reject { |attribute| exceptions.include?(attribute) }
      .each { |attribute| self[attribute] = nil }
    save!
  end
end
