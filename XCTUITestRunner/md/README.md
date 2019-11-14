### 安装 libimobiledevice
libimobiledevice 是一个使用原生协议与苹果iOS设备进行通信的库。通过这个库我们的 Mac OS 能够轻松获得 iOS 设备的信息。

```
brew install --HEAD libimobiledevice
```

使用方法：
```
# 查看 iOS 设备日志

idevicesyslog

# 查看链接设备的UDID

idevice_id --list

# 查看设备信息

ideviceinfo

# 获取设备时间

idevicedate

# 获取设备名称

idevicename

# 端口转发

iproxy XXXX YYYY

# 屏幕截图
idevicescreenshot
```

### 安装 Carthage
Carthage 是一款iOS项目依赖管理工具，与 Cocoapods 有着相似的功能，可以帮助你方便的管理三方依赖。它会把三方依赖编译成 framework，以 framework 的形式将三方依赖加入到项目中进行使用和管理。

WebDriverAgent 本身使用了 Carthage 管理项目依赖，因此需要提前安装 Carthage。
```
brew install carthage
```

### 安装 WebDriverAgent
WebDriverAgent 是 Facebook 推出的一款 iOS 移动测试框架，能够支持模拟器以及真机。
WebDriverAgent 在 iOS 端实现了一个 WebDriver server ，借助这个 server 我们可以远程控制 iOS 设备。你可以启动、杀死应用，点击、滚动视图，或者确定页面展示是否正确。

- 从 github 克隆 WebDriverAgent 的源码。
```
git clone https://github.com/facebook/WebDriverAgent.git
```

- 运行初始化脚本，确保之前已经安装过 Carthage。
```
cd WebDriverAgent
./Scripts/bootstrap.sh
```
脚本完成后可以打开工程文件，根据自己的开发者证书对 bundleid、证书等信息做下配置。

### 运行 WebDriverAgent
运行 WebDriverAgent 相当于在你的目标设备启动了一个服务器，它接收来自 WDA 客户端（一般是你的电脑）的脚本请求并执行，实现启动、杀死应用，点击、滚动视图等操作。

运行 WebDriverAgent 有两种方式，一种是打开 Xcode 运行，一种是使用脚本运行。

- 打开 Xcode 运行
菜单栏选择目标设备：
选择目标设备
Scheme 选择 WebDriverAgentRunner:
选择 WebDriverAgentRunner
最后运行 Product -> Test：
运行Product -> Test

一切正常的话，手机/模拟器上会出现一个无图标的 WebDriverAgent 应用，启动之后，马上又返回到桌面。这很正常不要奇怪。

此时控制台界面可以看到设备的 IP 地址:
设备的 IP 地址
通过上面给出的 IP地址 和端口，加上/status合成一个url地址。例如 [http://192.168.1.104:8100/status](http://192.168.1.104:8100/status)，然后浏览器打开。如果出现一串 JSON 输出，说明 WDA 安装成功了。

此时打开[http://192.168.1.104:8100/inspector](http://192.168.1.104:8100/inspector)，可以看到一个酷炫的界面。左边屏幕图像，右边具体的元素信息，用来查看界面都 UI 图层，方便写测试脚本用。


- 脚本运行（推荐）
这些是可执行的脚本内容, 可将YourPassword修改为你的MacOS用户密码, 在运行脚本时, 请选择是真机或者是模拟器运行, 如果是真机运行则需要用到上面安装`libimobiledevice`, 用以获取之前的iOS设备UUID
推荐直接写在一个 shell 文件里。
```
# 解锁keychain，以便可以正常的签名应用，将YourPassword修改为你的MacOS用户密码
PASSWORD="YourPassword" 
security unlock-keychain -p $PASSWORD ~/Library/Keychains/login.keychain
# 获取设备的UDID，用到了之前的 libimobiledevice
UDID=$(idevice_id -l | head -n1)
# 真机运行测试
xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination "id=$UDID" test
# 模拟器运行测试
#xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination "platform=iOS Simulator,name=iPhone X" test
```

脚本运行完成后，同样手机/模拟器上会出现一个无图标的 WebDriverAgent 应用，启动之后，马上又返回到桌面。此时终端会输出 IP 地址和端口。

### 端口转发
有些国产的iPhone机器通过手机的IP和端口还不能访问，此时需要将手机的端口转发到Mac上。需要用到之前安装的 libimobiledevice 这个库。
```
# 把当前连接的 iOS 设备端口转发到 MacOS 的端口, 比如以下: 将手机8100断口转发到Mac的8100断开
iproxy 8100 8100
```
设置转发断开完成后, 可以直接使用 [http://localhost:8100/status](http://localhost:8100/status)在MacOS的浏览器 查看是否返回 JSON。inspector 也可以使用 [http://localhost:8100/inspector](http://localhost:8100/inspector )访问。


### 安装 facebook-wda 客户端 (本项目已脱离WDA的server端, 仅供参考, 不用安装 )
上面我们在 iOS 设备上启动了 WDA 的服务端。为了运行 Mac OS 上的脚本，我们需要在 Mac OS 上安装 WDA 客户端。
facebook-wda 就是 WDA 的 Python 客户端库，通过直接构造HTTP请求直接跟WebDriverAgent通信。

安装 WDA python 客户端，可以上官网下载安装，但推荐使用pip安装。
```
# 安装 WDA python 客户端，微信跳一跳是 python3 编写，因此使用 pip3 安装
pip3 install --pre facebook-wda
```

图左侧为 PC 端，右侧为 iOS 端。PC 端（MacOS）运行 WebDriverAgent 工程，令 iOS 端启动 WDA 的 App， 这个 App 实现了一个 WebDriver server。然后 PC 端（可以不是运行 WDA 工程的那台 PC）作为客户端运行测试用例脚本并以 http 协议向 iOS 端的 WDA App 发起请求。最后 iOS 端的 WDA App 接受请求并且启动被测 App 执行测试用例。

需要注意的是，整个过程的服务端和客户端与我们平常理解的完全相反。这里 iOS 端是作为服务端，而运行测试脚本的 PC 端反而是发起请求的客户端。


### 参考资料
[mac 系统使用macaca inspector 获取iphone真机应用元素](https://www.cnblogs.com/testway/p/6298126.html?utm_source=itdadao&utm_medium=referral)



### Class Chain 
 s(name=u'请输入手机号码', className='StaticText').set_text("18810181988\n")
 'class chain' 
 **/XCUIElementTypeStaticText[`name == '请输入手机号码'`]
 **/XCUIElementTypeStaticText[`name == '请输入手机号码'`]
