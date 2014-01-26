#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "CVAPIBlueprintStubs"
  s.version      = "0.1.0"
  s.summary      = "Automatically creates stubs from API Blueprint AST files."
  s.description  = <<-DESC
                    Automatically creates stubs from API Blueprint AST files. You can use this library with OHHTTPStubs library to fake network API connections.
                   DESC
  s.homepage     = "https://github.com/keremk/CVAPIBlueprintStub"
  s.license      = 'MIT'
  s.author       = "Kerem Karatal"
  s.source       = { :git => "https://github.com/keremk/CVAPIBlueprintStub.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'SystemConfiguration'
  # s.dependency 'JSONKit', '~> 1.4'
end
