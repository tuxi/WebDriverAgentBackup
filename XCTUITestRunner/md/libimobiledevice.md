#  libimobiledevice 和 ios-deploy
ios 的终端命令一般使用第三方的开源库工具，下面介绍两种：libimobiledevice、ios-deploy

### libimobiledevice
libimobiledevice 是一个跨平台的软件库，支持 iPhone®, iPod Touch®, iPad® and Apple TV® 等设备的通讯协议。不依赖任何已有的私有库，不需要越狱。应用软件可以通过这个开发包轻松访问设备的文件系统、获取设备信息，备份和恢复设备，管理 SpringBoard 图标，管理已安装应用，获取通讯录、日程、备注和书签等信息，使用 libgpod 同步音乐和视频。

- 安装方式
```
brew install --HEAD libimobiledevice    # 安装最新的更新，支持 iOS 10
brew install ideviceinstaller           # 仅在 iOS9工作
```

- 常用命令
1. 查看当前所连接的设备
```
idevice_id -l               # 显示当前所连接的设备[udid]，包括 usb、WiFi 连接
instruments -s devices      # 列出设备包括模拟器、真机及 mac 电脑本身
```
2. 安装应用
xxx.ipa为应用在本地的路径
```
ideviceinstaller -u [udid] -i [xxx.ipa] # 给指定连接的设备安装应用
```
3. 卸载应用
bundleId为应用的包名
```
ideviceinstaller -u [udid] -U [bundleId] # 给指定连接的设备卸载应用
```
4. 查看设备已安装的应用
```
ideviceinstaller -u [udid] -l                   # 指定设备，查看安装的第三方应用
ideviceinstaller -u [udid] -l -o list_user      # 指定设备，查看安装的第三方应用
ideviceinstaller -u [udid] -l -o list_system    # 指定设备，查看安装的系统应用
ideviceinstaller -u [udid] -l -o list_all       # 指定设备，查看安装的系统应用和第三方应用
```
5. 获取设备信息
```
ideviceinfo -u [udid]                       # 指定设备，获取设备信息
ideviceinfo -u [udid] -k DeviceName         # 指定设备，获取设备名称：iPhone6s
idevicename -u [udid]                       # 指定设备，获取设备名称：iPhone6s
ideviceinfo -u [udid] -k ProductVersion     # 指定设备，获取设备版本：10.3.1
ideviceinfo -u [udid] -k ProductType        # 指定设备，获取设备类型：iPhone8,1
ideviceinfo -u [udid] -k ProductName        # 指定设备，获取设备系统名称：iPhone OS
ios-deploy
ios-deploy 同样是一个安装和调试应用的命令行工具。0需要一个有效的开发者证书，已安装 Xcode 7以上的版本。
```
安装方式
安装 node (已安装可略过)
```
brew install node
```
安装ios-deploy
```
npm install -g ios-deploy
```
开发者证书安装，请找 iOS 开发吧。

常用命令
1. 查看当前所连接的设备
```
ios-deploy -c               # 查看连接的设备包括：usb、wifi 连接
ios-deploy -c --no-wifi     # 查看连接的设备（usb），忽略 WiFi 连接的
```
2. 安装应用
xxx.app为 Xcode 编译后的应用安装包路径
```
ios-deploy --id [udid] --bundle [xxx.app] # 给指定应用安装应用
```
3. 卸载应用
```
ios-deploy --id [udid] --uninstall_only --bundle_id [bundleId] # 给指定连接的设备卸载应用
```
4. 查看设备已安装的应用
```
ios-deploy --id [udid] --list_bundle_id     # 指定设备安装的所有应用，包括系统应用和第三方应用
ios-deploy --id [udid] --exists --bundle_id     # 指定设备检查指定应用是否已经安装
```

