#
# Be sure to run `pod lib lint TZToolKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TZToolKit"
  s.version          = "0.0.3"
  s.summary          = "TZToolKit"
  s.description      = <<-DESC
                       A collection of convenient code for Cocoa.
                       DESC
  s.homepage         = "https://github.com/hysteria/TZToolKit"
  # s.screenshots     = ""
  s.license          = 'WTFPL'
  s.author           = { "Zhou Hangqing" => "zhouhangqing@gmail.com" }
  s.source           = { :git => "https://github.com/hysteria/TZToolKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/zhoutuizhi'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TZToolKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'AssetsLibrary', 'UIKIt'
  # s.dependency 'AFNetworking', '~> 2.3'
end
