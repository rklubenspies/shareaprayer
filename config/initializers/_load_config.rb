if !Rails.env.production?
  ENV = YAML.load_file("#{Rails.root}/config/keys.yml")[Rails.env]
end