
### xcode构建webdriverAgent时报错Messaging unqualified id的解决办法
在使用xcode构建webdriverAgent时，提示build failed,报错信息为：semantic issue:Messaging unqualified id，可以参考以下解决方案
```
　　xcode版本：10.2

　　ios版本：10.3

　　appium版本：1.7.2
```

#### 方法一：
打开终端进入webdriver的目录，我的目录如下
```
xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination 'id=' GCC_TREAT_WARNINGS_AS_ERRORS=0 test
```
命令中的id填入你自己设备的udid,等待构建完成，构建完成后，你的设备将会出现webdriverAgent的图标，表示构建成功。
如果方法一失败，可以尝试方法二


##### 方法二：
找到如下文件
```
/Applications/Appium.app/Contents/Resources/app/node_modules/appium/node_modules/appium-xcuitest-driver/WebDriverAgent/Configurations/ProjectSettins.xcconfig
```
将
```
WARNING_CFLAGS = $(inherited) -Weverything -Wno-objc-missing-property-synthesis -Wno-unused-macros -Wno-disabled-macro-expansion -Wno-gnu-statement-expression -Wno-language-extension-token -Wno-overriding-method-mismatch -Wno-missing-variable-declarations -Rno-module-build -Wno-auto-import -Wno-objc-interface-ivars -Wno-documentation-unknown-command -Wno-reserved-id-macro -Wno-unused-parameter -Wno-gnu-conditional-omitted-operand -Wno-explicit-ownership-type -Wno-date-time -Wno-cast-align -Wno-cstring-format-directive -Wno-double-promotion -Wno-partial-availability
```
　　
　　修改为
```
WARNING_CFLAGS = $(inherited) -Weverything -Wno-objc-missing-property-synthesis -Wno-unused-macros -Wno-disabled-macro-expansion -Wno-gnu-statement-expression -Wno-language-extension-token -Wno-overriding-method-mismatch -Wno-missing-variable-declarations -Rno-module-build -Wno-auto-import -Wno-objc-interface-ivars -Wno-documentation-unknown-command -Wno-reserved-id-macro -Wno-unused-parameter -Wno-gnu-conditional-omitted-operand -Wno-explicit-ownership-type -Wno-date-time -Wno-cast-align -Wno-cstring-format-directive -Wno-double-promotion -Wno-partial-availability -Wno-objc-messaging-id
```

再次build即可成功


### Test Failure
通过xcode查看Test log:
```
The test runner encountered an error (Failed to establish communication with the test runner. (Underlying error: Unable to connect to test manager on 265d34997640921b66d69b807f774f11ce3404bd. (Underlying error: Could not connect to the device.)))
```
解决方法:
1.查看证书是否正确, 配置正确的证书, 以便能正常运行Test
2.尝试更换其他iOS设备或模拟器运行本Test, 如果在其他运行正常, 则重启你的iOS 设备, 再次运行Test.
[参考资料](https://stackoverflow.com/questions/53643318/xctests-canceling-prematurely)


### Test Failure
通过xcode查看Test log:
```
WebDriverAgentRunner-Runner.app (341) encountered an error (Early unexpected exit, operation never finished bootstrapping - no restart will be attempted. (Underlying error: The test runner exited with code 1 before checking in.))
```
解决方法:
证书问题,  虽然看似证书签名没有问题, 但实际上执行Test时就是Falure, 我们需要在各个target的build settings 中将bundle identifier 修改为自己的.
卸载iOS 设备的WebDriverAgent , Xcode重新执行Test


### Test Failure
```
bjc[673]: Class GCDAsyncSocket is implemented in both /private/var/containers/Bundle/Application/6CD19E07-EAA6-4651-86E3-948BF1822DAA/WebDriverAgentRunner-Runner.app/PlugIns/WebDriverAgentRunner.xctest/Frameworks/WebDriverAgentLib.framework/Frameworks/RoutingHTTPServer.framework/RoutingHTTPServer (0x108ea5788) and /private/var/containers/Bundle/Application/6CD19E07-EAA6-4651-86E3-948BF1822DAA/WebDriverAgentRunner-Runner.app/PlugIns/WebDriverAgentRunner.xctest/Frameworks/WebDriverAgentLib.framework/Frameworks/CocoaAsyncSocket.framework/CocoaAsyncSocket (0x108e0c6b8). One of the two will be used. Which one is undefined.
```
可忽略此日志


### 因为它已损坏或丢失必要的资源。 请尝试重新安装软件包
```
2019-11-16 18:47:56.424273+0800 MobileAutomationUITests-Runner[9973:647501] 未能载入软件包“MobileAutomationUITests”，因为它已损坏或丢失必要的资源。 请尝试重新安装软件包。
2019-11-16 18:47:56.424371+0800 MobileAutomationUITests-Runner[9973:647501] (dlopen_preflight(/var/containers/Bundle/Application/E70055A3-4085-42EA-8946-26A38B3080C3/MobileAutomationUITests-Runner.app/PlugIns/MobileAutomationUITests.xctest/MobileAutomationUITests): Library not loaded: @rpath/MobileAutomationLib.framework/MobileAutomationLib
  Referenced from: /var/containers/Bundle/Application/E70055A3-4085-42EA-8946-26A38B3080C3/MobileAutomationUITests-Runner.app/PlugIns/MobileAutomationUITests.xctest/MobileAutomationUITests
  Reason: image not found)
  ```
  这是问题可能由两种情况引发： 
  1. 在UITest target中引入的动态库，其本身又依赖其他动态库，所以需要在UITest target的Build Phases中添加Copy framework 并将其依赖的库加入
  [参考资料](https://www.cnblogs.com/grandyang/p/8203024.html)
  2.动态库签名与UITest 签名不一致导致。
  
  ### Command CodeSign failed with a nonzero exit code
  ```
  CodeSign /Users/swae/Library/Developer/Xcode/DerivedData/MobileAutomation-dacujukpfzfhafbmfmesuiyfmlrg/Build/Products/Debug-iphoneos/MobileAutomationUITests-Runner.app/PlugIns/MobileAutomationUITests.xctest/Frameworks/TesseractOCR.framework (in target 'MobileAutomationUITests' from project 'MobileAutomation')
      cd /Users/swae/Documents/Github/MobileAutomation/MobileAutomation
      export CODESIGN_ALLOCATE=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/codesign_allocate
      
  Signing Identity:     "Apple Development: Xiaoyuan Yang (29H47J82NP)"
  Provisioning Profile: "iOS Team Provisioning Profile: *"
                        (bcca1c8c-5f4b-4077-9dba-870c9a69f351)

      /usr/bin/codesign --force --sign 7BB1896DCDD3C48C1DFDD5BDCA49B0A47DAB5253 --timestamp=none --preserve-metadata=identifier,entitlements,flags /Users/swae/Library/Developer/Xcode/DerivedData/MobileAutomation-dacujukpfzfhafbmfmesuiyfmlrg/Build/Products/Debug-iphoneos/MobileAutomationUITests-Runner.app/PlugIns/MobileAutomationUITests.xctest/Frameworks/TesseractOCR.framework

  /Users/swae/Library/Developer/Xcode/DerivedData/MobileAutomation-dacujukpfzfhafbmfmesuiyfmlrg/Build/Products/Debug-iphoneos/MobileAutomationUITests-Runner.app/PlugIns/MobileAutomationUITests.xctest/Frameworks/TesseractOCR.framework: bundle format is ambiguous (could be app or framework)
  Command CodeSign failed with a nonzero exit code
  ```
  解决方法：
 将WebDriverAgentRunner的Build Phases 下面的framework 取消勾选Code sign on copy。
[参考资料](https://objc.com/article/76)
