Pod::Spec.new do |spec|

  spec.name         = "TapppPanelLibrary"
  spec.version      = "1.0.11"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = "This will be test description for inmplememting pod file."

  spec.homepage     = "https://github.com/ravimaru2022/Tappp_Panel_library.git"
  spec.license      =  'MIT'
  spec.author       = { "ravimaru2022" => "ravi.maru@tudip.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/ravimaru2022/Tappp_Panel_library.git", :tag => "#{spec.version}" }
  spec.source_files  = "TapppPanelLibrary/**/*.{h,m,swift}"
  spec.resources     = "TapppPanelLibrary/**/*.{png, json, html, ico, map, ttf, js}"
  spec.resource_bundles = {
   'web-build' => ['TapppPanelLibrary/web-build/*.png']
  }
  #spec.resources     = "TapppPanelLibrary/**/*.{html}"
  #spec.source_files  = "TapppPanelLibrary/web-build/**/*.{png, json, html, ico, map, ttf}"

end