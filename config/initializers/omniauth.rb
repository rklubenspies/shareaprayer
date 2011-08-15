Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, ENV['FB_ID'], ENV['FB_SECRET'], {:scope => 'publish_stream,email,user_about_me,user_religion_politics,offline_access'}
end