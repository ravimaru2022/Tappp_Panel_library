Pod::Spec.new do |spec|

  spec.name         = "TapppPanelLibrary"
  spec.version      = "1.3.3"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = "This will be test description for inmplememting pod file."

  spec.homepage     = "https://github.com/ravimaru2022/Tappp_Panel_library.git"
  spec.license      =  'MIT'
  spec.author       = { "ravimaru2022" => "ravi.maru@tudip.com" }

  spec.ios.deployment_target = "13.0"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/ravimaru2022/Tappp_Panel_library.git", :tag => "#{spec.version}" }
  spec.source_files  = "TapppPanelLibrary/**/*.{h,m,swift}"
  spec.resources     = "TapppPanelLibrary/**/*.{png, json, html, ico, map, ttf, js}"
  spec.resource_bundles = {
   'web-build' => ['TapppPanelLibrary/amplifyconfiguration.json',
                   'TapppPanelLibrary/*.html',
                   'TapppPanelLibrary/web-build/*.png',
                   'TapppPanelLibrary/web-build/*.json',
                   'TapppPanelLibrary/web-build/*.ico',
                   'TapppPanelLibrary/web-build/*.html',
                   'TapppPanelLibrary/web-build/fonts/*.ttf',
                   'TapppPanelLibrary/web-build/static/js/*.js',
                   'TapppPanelLibrary/web-build/static/js/*.map'],
    'dist' => ['TapppPanelLibrary/dist/*.js',
               'TapppPanelLibrary/dist/*.txt',
               'TapppPanelLibrary/dist/*.map',
               'TapppPanelLibrary/dist/*.html']
  }
  #spec.ios.dependency 'AFNetworking', '~> 2.3'
  #spec.ios.dependency 'Amplify'
  #spec.ios.dependency 'AmplifyPlugins/AWSCognitoAuthPlugin'
  #spec.ios.dependency 'AmplifyPlugins/AWSAPIPlugin'
  #spec.ios.dependency 'AmplifyPlugins/AWSDataStorePlugin'
  spec.ios.dependency 'Sentry'

  #spec.ios.dependency   ':spm => https://github.com/aws-amplify/amplify-swift.git'
  #spec.ios.dependency 'AWSAPIPlugin'
  #spec.ios.dependency 'AWSPinpointAnalyticsPlugin'
  #spec.ios.dependency 'AWSCognitoAuthPlugin'
  #spec.ios.dependency 'AWSDataStorePlugin'
  #spec.ios.dependency 'AWSLocationGeoPlugin'
  #spec.ios.dependency 'AWSS3StoragePlugin'
  #spec.dependency =  "aws-amplify" "https://github.com/aws-amplify/aws-sdk-ios-spm"
  #spec.resources     = "TapppPanelLibrary/**/*.{html}"
  #spec.source_files  = "TapppPanelLibrary/web-build/**/*.{png, json, html, ico, map, ttf}"

end