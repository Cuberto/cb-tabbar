Pod::Spec.new do |s|
  s.name             = 'CBTabBarController'
  s.version          = '0.9.2'
  s.summary          = 'One another nice animated tabbar'
  s.homepage         = 'https://github.com/Cuberto/cb-tabbar'
  s.license          = 'MIT'
  s.author           = { 'askopin@gmail.com' =>  'askopin@gmail.com' }
  s.source           = { :git => 'https://github.com/Cuberto/cb-tabbar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cuberto'
  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'
  s.source_files = 'CBTabBarController/Classes/**/*'
  s.resources =  'CBTabBarController/Assets/**/*.{png,storyboard}'
end
