Pod::Spec.new do |spec|

  spec.name         = "TapppPanelLibrary"
  spec.version      = "1.5.8"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = "This will be test description for inmplememting pod file."

  spec.homepage     = "https://github.com/ravimaru2022/Tappp_Panel_library.git"
  spec.license      =  'MIT'
  spec.author       = { "ravimaru2022" => "ravi.maru@tudip.com" }

  spec.ios.deployment_target = "13.0"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/ravimaru2022/Tappp_Panel_library.git", :tag => "#{spec.version}" }
  spec.source_files  = "TapppPanelLibrary/**/*.{h,m,swift}"
  #spec.resources     = "TapppPanelLibrary/*.{json}"
  spec.resource_bundles = {
    'dist' => ['TapppPanelLibrary/dist/*.js',
               'TapppPanelLibrary/dist/*.json',
               'TapppPanelLibrary/dist/*.txt',
               'TapppPanelLibrary/dist/*.map',
               'TapppPanelLibrary/dist/*.html']
  }
  spec.ios.dependency 'Sentry'
  # dependencies : [
  #       .package(url: "https://github.com/aws-amplify/amplify-swift.git", .upToNextMajor(from: "2.0.0"))
  # ]
  # spec.ios.dependency 'Amplify'
  # spec.ios.dependency 'AWSAPIPlugin'
  # spec.ios.dependency 'AWSPinpointAnalyticsPlugin'
  # spec.ios.dependency 'AWSCognitoAuthPlugin'
  # spec.ios.dependency 'AWSDataStorePlugin'
  # spec.ios.dependency 'AWSLocationGeoPlugin'
  # spec.ios.dependency 'AWSS3StoragePlugin'


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