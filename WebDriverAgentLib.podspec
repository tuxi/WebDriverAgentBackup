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
  spec.ios.deployment_target = "9.0"


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
  spec.xcconfig = { 
    'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', 
    'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks', 
    # 添加系统PrivateFrameworks后, 不能包含ENABLE_BITCODE
    'ENABLE_BITCODE' => 'NO', 
  } 
  

  spec.requires_arc = true
  # 依赖的第三方库
  spec.dependency "CocoaAsyncSocket"
  spec.dependency "RoutingHTTPServer"
  spec.dependency 'YYCache', '~> 1.0.4'

  # spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  # spec.user_target_xcconfig = { 'MY_SUBSPEC' => 'YES' }

  # Add to your podfile
#  post_install do |installer|
#    installer.pods_project.targets.each do |target|
#      target.build_configurations.each do |config|
#        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'DD_LEGACY_MACROS=1']
#      end
#    end
#  end

  # pod spec lint --allow-warnings --use-libraries --sources=https://github.com/CocoaPods/Specs.git --verbose


end
