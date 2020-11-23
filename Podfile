# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'DriverApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DriverApp
    pod 'RxSwift'
  	pod 'RxCocoa'

    pod 'Alamofire'
    pod 'AlamofireImage'

    pod 'GoogleMaps'
    pod 'GooglePlaces'

    pod 'SwiftyJSON'
  
  	pod 'Firebase/Core'
  	pod 'Firebase/Database'
  	pod 'Firebase/Analytics'
  	pod 'Firebase/Crashlytics'
    
    pod 'JGProgressHUD'
    
    pod 'BulletinBoard'

end


post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end
