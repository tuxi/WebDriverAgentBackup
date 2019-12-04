#
#  Be sure to run `pod spec lint WebDriverAgentLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "WebDriverAgentLib"
  spec.version      = "0.9"
  spec.summary      = "A short description of WebDriverAgentLib."

  spec.description  = "FaceBook WebDriverAgent Backup in cocoapods."

  spec.homepage     = "https://github.com/tuxi/WebDriverAgentBackup"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # 框架遵守的开源协议
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "xiaoyuan" => "seyooe@gmail.com" }
  spec.social_media_url   = "https://twitter.com/seyooe"

  #  When using multiple platforms
  spec.ios.deployment_target = "4.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  # 本地地址
  #spec.source       = { :git => "WebDriverAgentLib", :tag => "#{spec.version}" }
  # 远程地址
  spec.source       = { :git => "https://github.com/tuxi/WebDriverAgentBackup.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "WebDriverAgentLib", "WebDriverAgentLib/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  # 公开的头文件
  #spec.public_header_files = "WebDriverAgentLib/**/*.h",
  spec.public_header_files = "WebDriverAgentLib/Public/*.h",  "WebDriverAgentLib/Routing/FBWebServer.h", "WebDriverAgentLib/Utilities/FBConfiguration.h", "WebDriverAgentLib/Utilities/FBFailureProofTestCase.h", "WebDriverAgentLib/PrivateHeaders/AccessibilityUtilities/AXSettings.h", "WebDriverAgentLib/PrivateHeaders/UIKitCore/UIKeyboardImpl.h", "WebDriverAgentLib/PrivateHeaders/TextInput/TIPreferencesController.h", "WebDriverAgentLib/PrivateHeaders/XCTest/XCTestCase.h", "WebDriverAgentLib/PrivateHeaders/XCTest/CDStructures.h", "WebDriverAgentLib/Utilities/FBDebugLogDelegateDecorator.h", "WebDriverAgentLib/PrivateHeaders/XCTest/XCDebugLogDelegate-Protocol.h"
  
  # 私有的头文件
  #spec.private_header_files = "FBBaseActionsSynthesizer.h"

  

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  #spec.resources = "Resources/*.png"



  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # 依赖的frameworks
  spec.frameworks       = ["XCTest", "XCTAutomationSupport"]
  # 依赖的libraries
  spec.libraries        = [ "Accessibility", "xml2" ]
  # 引用xml2库,但系统会找不到这个库的头文件，需在spec.xcconfig配合使用(这里省略lib)
  # 在pod target项的Header Search Path中配置:${SDK_DIR}/usr/include/libxml2.2
  spec.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', 'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks', 'ENABLE_BITCODE' => 'NO' } 
  # 添加系统PrivateFrameworks后, 不能包含ENABLE_BITCODE



  spec.requires_arc = true

  # 依赖的第三方库
  spec.dependency "CocoaAsyncSocket"
  spec.dependency "RoutingHTTPServer"
  spec.dependency "YYCache"
  

end
