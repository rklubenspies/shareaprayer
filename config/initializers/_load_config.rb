if !Rails.env.production?
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/keys.yml")[Rails.env]
end