# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'TSS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'Alamofire'
pod 'KVSpinnerView'
pod 'DropDown', '~> 2.3.3'
pod 'SDWebImage'
pod 'Cosmos', '~> 25.0'
pod 'TikTokOpenSDK'
pod 'FBSDKCoreKit', '~> 15.0'
pod 'FBSDKLoginKit', '~> 15.0'
pod 'FBSDKShareKit', '~> 15.0'
pod 'TwitterKit', '~> 3.0'
  # Pods for TSS

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'TwitterCore'
        target.build_configurations.each do |config|
          config.build_settings['VALID_ARCHS'] = 'arm64 armv7'
        end
      end
    end
  end
  
end
