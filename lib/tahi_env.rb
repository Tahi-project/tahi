require 'active_support/core_ext/string/strip'
require File.dirname(__FILE__) + '/tahi_env/env_var'
require File.dirname(__FILE__) + '/tahi_env/boolean_validator'
require File.dirname(__FILE__) + '/tahi_env/presence_validator'

class TahiEnv
  include ActiveModel::Validations

  class Error < ::StandardError ; end
  class InvalidEnvironment < Error ; end
  class MissingEnvVarRegistration < Error ; end

  class RequiredEnvVar < EnvVar ; end
  class OptionalEnvVar < EnvVar ; end

  def self.validate!
    instance.validate!
  end

  def self.env_vars
    @env_vars = @env_vars || {}
  end

  def self.instance
    @instance ||= TahiEnv.new
  end

  def self.optional(env_var, type = nil, default: nil)
    optional_env_var = OptionalEnvVar.new(
      env_var,
      type,
      default: default
    )
    register_env_var(optional_env_var)
  end

  def self.required(env_var, type = nil, **kwargs)
    default_value = kwargs[:default]
    if_method = kwargs[:if]

    required_env_var = RequiredEnvVar.new(
      env_var,
      type,
      default: default_value
    )
    register_env_var(required_env_var)

    validation_args = required_env_var.boolean? ? { boolean: true } : { presence: true }

    validation_args[:if] = if_method if if_method
    validates env_var, **validation_args
  end

  def self.register_env_var(env_var)
    env_vars[env_var.env_var] = env_var

    # TahiEnv#APP_NAME
    reader_method = env_var.env_var
    define_method(reader_method) do
      env_var.raw_value_from_env
    end

    # TahiEnv#app_name
    # TahiEnv#orcid_enabled?
    reader_method = "#{env_var.env_var.downcase}"
    reader_method << "?" if env_var.boolean?
    define_method(reader_method) do
      env_var.value
    end
  end

  def self.method_missing(method, *args, &blk)
    if instance.respond_to?(method)
      instance.send(method, *args, &blk)
    else
      method = method.to_s
      fail MissingEnvVarRegistration, <<-ERROR_MSG.strip_heredoc
        undefined method #{method.inspect} for #{self}. Is the
        #{method.upcase} env var registered in #{self}?
      ERROR_MSG
    end
  end

  # App
  required :APP_NAME
  required :ADMIN_EMAIL
  required :PASSWORD_AUTH_ENABLED
  required :RAILS_ASSET_HOST
  required :RAILS_ENV
  required :RAILS_SECRET_TOKEN
  required :DEFAULT_MAILER_URL
  required :FROM_EMAIL
  optional :DISABLE_FORCE_SSL, :boolean, default: false
  optional :MAX_ABSTRACT_LENGTH
  optional :PING_URL
  optional :PUSHER_SOCKET_URL
  optional :REPORTING_EMAIL

  # Amazon S3
  required :S3_URL
  required :S3_BUCKET
  required :AWS_ACCESS_KEY_ID
  required :AWS_SECRET_ACCESS_KEY
  required :AWS_REGION

  # Basic Auth
  optional :BASIC_AUTH_REQUIRED, :boolean, default: false
  required :BASIC_HTTP_USERNAME, if: :basic_auth_required?
  required :BASIC_HTTP_PASSWORD, if: :basic_auth_required?

  # Bugsnag
  required :BUGSNAG_API_KEY
  optional :BUGSNAG_JAVASCRIPT_API_KEY

  # CAS
  required :CAS_ENABLED, :boolean
  required :CAS_SIGNUP_URL, if: :cas_enabled?
  required :CAS_CALLBACK_URL, if: :cas_enabled?
  required :CAS_CA_PATH, if: :cas_enabled?
  required :CAS_DISABLE_SSL_VERIFICATION, if: :cas_enabled?
  required :CAS_HOST, if: :cas_enabled?
  required :CAS_LOGIN_URL, if: :cas_enabled?
  required :CAS_LOGOUT_URL, if: :cas_enabled?
  required :CAS_PORT, if: :cas_enabled?
  required :CAS_SERVICE_VALIDATE_URL, if: :cas_enabled?
  required :CAS_SSL, if: :cas_enabled?
  required :CAS_UID_FIELD, if: :cas_enabled?

  # EM / Editorial Manager
  optional :EM_DATABASE

  # Event Stream
  required :EVENT_STREAM_WS_HOST
  required :EVENT_STREAM_WS_PORT

  # FTP
  required :FTP_HOST
  required :FTP_USER
  required :FTP_PASSWORD
  required :FTP_PORT
  required :FTP_DIR

  # Hipchat
  optional :HIPCHAT_AUTH_TOKEN

  # Heroku
  optional :HEROKU_APP_NAME
  optional :HEROKU_PARENT_APP_NAME

  # iHat
  required :IHAT_URL
  optional :IHAT_CALLBACK_HOST
  optional :IHAT_CALLBACK_PORT

  # Mailsafe
  optional :MAILSAFE_REPLACEMENT_ADDRESS

  # NED
  required :NED_API_URL
  required :NED_CAS_APP_ID
  required :NED_CAS_APP_PASSWORD
  optional :NED_DISABLE_SSL_VERIFICATION, :boolean, default: false
  required :USE_NED_INSTITUTIONS, :boolean

  # Newrelic
  optional :NEWRELIC_KEY
  optional :NEWRELIC_APP_NAME

  # Orcid
  optional :ORCID_ENABLED, :boolean, default: false
  required :ORCID_API_HOST, if: :orcid_enabled?
  required :ORCID_SITE_HOST, if: :orcid_enabled?

  # Puma
  optional :PUMA_WORKERS
  optional :MAX_THREADS
  optional :PORT
  optional :RACK_ENV

  # Pusher / Slanger
  required :PUSHER_URL
  required :DISABLE_PUSHER_SSL_VERIFICATION
  required :PUSHER_VERBOSE_LOGGING

  # Salesforce
  optional :SALESFORCE_ENABLED, :boolean, default: true
  required :DATABASEDOTCOM_HOST, if: :salesforce_enabled?
  required :DATABASEDOTCOM_CLIENT_ID, if: :salesforce_enabled?
  required :DATABASEDOTCOM_CLIENT_SECRET, if: :salesforce_enabled?
  required :DATABASEDOTCOM_USERNAME, if: :salesforce_enabled?
  required :DATABASEDOTCOM_PASSWORD, if: :salesforce_enabled?

  # Segment IO
  optional :SEGMENT_IO_WRITE_KEY

  # Sendgrid
  required :SENDGRID_USERNAME
  required :SENDGRID_PASSWORD

  # Sidekiq
  optional :SIDEKIQ_CONCURRENCY

  def validate!
    unless valid?
      error_message = "Environment validation failed:\n\n"
      errors.full_messages.each do |error|
        error_message << "* #{error}\n"
      end
      error_message << "\n"
      fail InvalidEnvironment, error_message
    end
  end
end
