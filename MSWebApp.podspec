#
# Be sure to run `pod lib lint MSWebApp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSWebApp'
  s.version          = '1.0.4'
  s.summary          = 'MSWebApp is used for dynamic manage the modules.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
What's `MSWebApp`: More and more html pages and frameworks used in app, like: react-native, weex, phone-gap and more. Learning that will cost a lot of time. more times, we only need a little html pages. `MSWebApp` is used for dynamic manage the modules.

                       DESC

  s.homepage         = 'https://github.com/90Team/MSWebApp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dylan' => 'dylan@china.com' }
  s.source           = { :git => 'https://github.com/90Team/MSWebApp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.1'

  s.source_files = 'MSWebApp/Classes/**/*'
  
# s.resource_bundles = {
#  'MSWebApp' => ['MSWebApp/Assets/*.jpg', 'MSWebApp/Assets/*.htm']
# }

  s.public_header_files = 'MSWebApp/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'WebKit'
  s.dependency 'MKNetworking'
  s.dependency 'WebViewJavascriptBridge'
  s.dependency 'LKDBHelper'
  s.dependency 'WPZipArchive'
end
