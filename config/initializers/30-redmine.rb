I18n.default_locale = 'en'
I18n.backend = Redmine::I18n::Backend.new
# Forces I18n to load available locales from the backend
I18n.config.available_locales = nil

require 'redmine'

# Load the secret token from the Redmine configuration file
secret = Redmine::Configuration['bfd3d048710c6e3325d350195a56027b8c65f229891f2b3e660aae655e0e4572ac969d3cd13ded8ad8e560ff503b86da813ec162953a3371f1b6ee42f51aeabc']
if secret.present?
  RedmineApp::Application.config.secret_token = secret
end

if Object.const_defined?(:OpenIdAuthentication)
  openid_authentication_store = Redmine::Configuration['openid_authentication_store']
  OpenIdAuthentication.store =
    openid_authentication_store.present? ?
      openid_authentication_store : :memory
end

Redmine::Plugin.load
unless Redmine::Configuration['mirror_plugins_assets_on_startup'] == false
  Redmine::Plugin.mirror_assets
end

Rails.application.config.to_prepare do
  Redmine::FieldFormat::RecordList.subclasses.each do |klass|
    klass.instance.reset_target_class
  end
end
