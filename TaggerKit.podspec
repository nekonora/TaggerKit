#
# Be sure to run `pod lib lint TaggerKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TaggerKit'
  s.version          = '0.2.0'
  s.summary          = 'TaggerKit is a straightforward library that helps you implement tags in your iOS project.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library helps you to quickly implement tags in your iOS apps, so you can go on and test your idea without having to worry about logic and custom collection layouts.
                       DESC

  s.homepage         = 'https://github.com/nekonora/TaggerKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'registration.fi.za@outlook.com' => 'registration.fi.za@outlook.com' }
  s.source           = { :git => 'https://github.com/nekonora/TaggerKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/_nknr'

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.2'

  s.source_files = 'TaggerKit/Classes/**/*'
  
  s.resource_bundles = {
     'TaggerKit' => ['TaggerKit/Assets/*.png']
  }

  s.resources = 'TaggerKit/Assets/**/*.{png,storyboard}'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
