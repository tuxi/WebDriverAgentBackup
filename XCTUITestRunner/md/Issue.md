
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
