module URLHelper
  ENV_TO_URL_MAP ||= { uat: 'https://retailuat3.alldata.net' }.freeze

  def self.base_url_for_env(env = ENV['TEST_ENV'])
    ENV_TO_URL_MAP[env.to_s.downcase.to_sym]
  end

  def self.base_url_for_client(client_code = ENV['CLIENT_CODE'], env = ENV['TEST_ENV'])
    "#{base_url_for_env(env)}/#{client_code}"
  end

  def branded_url(postfix)
    page_url "#{URLHelper.base_url_for_client}#{postfix}"
  end

  def self.included(cls)
    cls.extend URLHelper
  end
end
