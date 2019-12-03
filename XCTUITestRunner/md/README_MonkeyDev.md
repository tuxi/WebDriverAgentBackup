# iOS 非越狱 通过MonkeyDev hook app

### 简介
[MonkeyDev Github](https://github.com/AloneMonkey/MonkeyDev)
MonkeyDev是集成OpenDev的的工具包, 但是OpenDev在13年就不在更新了,所以[AloneMonkey](https://www.jianshu.com/u/0a821cdd025c)就在此基础上做了进一步的更新,而且更加简单,更加傻瓜式.具体安装步骤可以查看原文博客.

### 步骤

#### 安装MonkeyDev
具体安装请参考[中文说明](https://github.com/AloneMonkey/MonkeyDev/wiki/%E5%AE%89%E8%A3%85)

安装完成后, 在Xcode 新建项目的模板中会出现MonkeyApp.

### 通过MonkeyApp 新建项目
##### 主要流程: 
- 通过PP助手下载的越狱ipa文件或者自己通过越狱机器砸壳的app
- 通过`class-dump`指令来查看所有包含类的头文件.然后编写动态库 (不深入研究, 可忽略)
- 通过`runtime`的机制动态注入到破壳文件中.
- 然后对注入完成的文件进行重新签名,最后安装应用程序.
其中MonkeyDev的作者已经把其中的三步进行了封装,

##### 创建项目
首先通过Xcode新建一个MonkeyApp项目

##### 添加iPA 或者 app
把我们的ipa或者app放到工程项目的`TargetApp`目录下, 注意里面的`put ipa or app here`文件不要删除


##### 运行项目
连接iOS设备, 执行run 将项目安装到你的设备并运行.


### 编写需要hook 的代码
在新建的MonkeyApp 项目中, 在`Logos`目录下的`.xm`文件中编写代码, 实现hook.

### 分析总结
- 一个完整的Xcode工程，包含一个App的主工程、一个dylib的动态链接库工程。
- 在App编译完成之后，可以将目标App完成与编译App之间的替换，这样完成移花接木的功能。
- 链接库功能中使用了theOS中的库，实现对OC方法的hook和C方法的hook。
- 实现ipa中签名文件替换，动态库的注入
- 可联调

注意：
注入链接库之后的App，bundleID随之改变，对于安全级别较高的app来说，校验了bundleID可能会提示非法客户端导致封号，但这个也可以通过hook解决。






