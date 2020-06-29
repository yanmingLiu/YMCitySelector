#
# Be sure to run `pod lib lint YMCitySelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMCitySelector'
  s.version          = '0.1.0'
  s.summary          = '3个table样式的城市选择器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
简洁高效的城市选择器，3个tableview组成，支持设置默认值(在show方法调用后才能设置默认值)，选择使用block回调，调用简单，只需要3行代码，即可实现漂亮的城市选择器。
                       DESC

  s.homepage         = 'https://github.com/yanmingLiu/YMCitySelector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yanmingLiu' => 'lwb374402328@gmail.com' }
  s.source           = { :git => 'https://github.com/yanmingLiu/YMCitySelector.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YMCitySelector/Classes/**/*'
  
   s.resource_bundles = {
     'YMCitySelector' => ['YMCitySelector/Assets/*']
   }

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
   s.dependency 'YYKit'
end
