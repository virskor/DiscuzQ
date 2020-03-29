Pod::Spec.new do |s|
  s.name             = 'flutter_user_agent'
  s.version          = '1.2.1'
  s.summary          = 'Retrieve user-agent properties.'
  s.description      = <<-DESC
Retrieve user-agent properties
                       DESC
  s.homepage         = 'https://github.com/j0j00/flutter_user_agent'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'j0j00' => 'jojodev@protonmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end