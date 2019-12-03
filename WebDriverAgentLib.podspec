#
#  Be sure to run `pod spec lint WebDriverAgentLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "WebDriverAgentLib"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of WebDriverAgentLib."

  spec.description  = "WebDriverAgentLib 测试框架"

  spec.homepage     = "http://github.com/tuxi/WebDriverAgentBackup"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # 框架遵守的开源协议
  spec.license      = 'MIT'


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "xiaoyuan" => "seyooe@gmail.com" }
  spec.social_media_url   = "https://twitter.com/seyooe"

  #  When using multiple platforms
  spec.ios.deployment_target = "9.0"
  spec.osx.deployment_target = "10.7"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "WebDriverAgentLib", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "WebDriverAgentLib", "WebDriverAgentLib/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  #spec.public_header_files = "WebDriverAgentLib/**/*.h",
  spec.public_header_files = "WebDriverAgentLib/Public/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  #spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


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
  # 添加PrivateFrameworks后, 不能包含ENABLE_BITCODE


  spec.requires_arc = true

  # 依赖的第三方库
  spec.dependency "YYCache"
  spec.dependency "CocoaAsyncSocket"
  spec.dependency "RoutingHTTPServer"
  

end
