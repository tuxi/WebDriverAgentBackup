#!/bin/sh

#  run.sh
#  WebDriverAgent
#
#  Created by xiaoyuan on 2019/11/13.
#  Copyright © 2019 Facebook. All rights reserved.


# 解锁keychain，以便可以正常的签名应用，将YourPassword修改为你的MacOS用户密码
PASSWORD="123456"
security unlock-keychain -p $PASSWORD ~/Library/Keychains/login.keychain
# 获取设备的UDID，用到了之前的 libimobiledevice
UDID=$(idevice_id -l | head -n1)
# 真机运行测试
xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination "id=$UDID" test
# 模拟器运行测试
#xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination "platform=iOS Simulator,name=iPhone X" test
