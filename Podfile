# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'RxSymbols' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Moya/RxSwift', '15.0.0'
  pod 'HandyJSON', '~> 5.0.2'
  pod 'Kingfisher', '~> 6.0.1'
  pod 'RxCocoa', '~> 6.5.0'
  pod 'RxDataSources', '~> 5.0'
  pod 'ESPullToRefresh', '~> 2.9.3'
  pod 'ProgressHUD', '~> 13.4'
  pod 'SwiftyJSON', '~> 5.0.0'
  #pod 'RxSwiftExt', '~> 5.2.0'
  pod 'RxGesture', '~> 4.0.4'
  pod 'RxWebKit', :git => 'https://github.com/RxSwiftCommunity/RxWebKit.git'
  pod 'Toast-Swift', '~> 5.0.1'
  # Pods for RxSymbols

end
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
         end
    end
  end
end
