
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
