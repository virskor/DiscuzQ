#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'clipboard_manager'
  s.version          = '0.0.3'
  s.summary          = 'flutter plugin to copy text to clipboard.'
  s.description      = <<-DESC
Flutter plugin to copy text to clipboard.
                       DESC
  s.homepage         = 'http://mranuran.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Anuran Barman' => 'anuranbarman@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

