Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '245221078839860', '062efadfd9f53d7075c0c25c66d1564d', {:scope => 'publish_stream,email,user_about_me,user_religion_politics,offline_access'}
end