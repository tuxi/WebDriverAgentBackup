//
// AutomationScript.swift
// DouyinApp
//
// Created by xiaoyuan on 2019/12/24.
// Copyright © 2019 寻宝天行. All rights reserved.
//

import UIKit
import WebDriverAgentLib

class AutomationScript {

    func start() {
        let verson = "9.2.0"
        let bundleId = "com.ss.iphone.ugc.Aweme"
         print("开始运行的自动化脚本, bundleId:\(bundleId), appversion:\(verson)")
        
        let commander = RTCommander()
        commander.terminateApp(withBundleId: bundleId)
        sleep(3)
        
        commander.launchApp(withBundleId: bundleId)
        sleep(6)
        
        
        // 检测我知道了弹框
        var knowAlert: XCUIElement?
        var retryNum = 2
        while knowAlert == nil, retryNum > 0 {
            knowAlert = commander.findElements(withClassName: nil, name: "我知道了", label: nil)?.first as? XCUIElement
            sleep(1)
            retryNum -= 1
        }
        knowAlert?.tap()
        sleep(3)
        
        // 登录操作
        let mineElement = commander.findElements(withClassName: "Button", name: nil, label: "我")?.first as? XCUIElement
        mineElement?.tap()
        sleep(3)
        
        let loginElement = commander.findElements(withClassName: "Button", name: nil, label: "其他手机号码登录")?.first as? XCUIElement
        if loginElement != nil {
            // 用户未登录
            loginElement?.tap()
            sleep(3)
            
            let passwordLoginElement = commander.findElements(withClassName: nil, name: "密码", label: nil)?.first as? XCUIElement
            passwordLoginElement?.tap()
            sleep(3)
            
            try! commander.setElementText("18810181988", forClassName: "TextField", name: "请输入手机号", tryCount: 3)
            sleep(3)
            try! commander.setElementText("sey308719", forClassName: "TextField", name: "请输入密码", tryCount: 3)
            sleep(3)
            
            // 点击 我已阅读并同意 抖音用户协议 和 隐私政策
            try! commander.tap(with: CGPoint(x: 49, y: 295))
            sleep(3)
            
            let loginElement = commander.findElements(withClassName: nil, name: "登录", label: nil)?.first as? XCUIElement
            loginElement?.tap()
            sleep(3)
            
        }
        
        
        do {
            // 滑动到下一个页面
            try commander.swipe(withDirection: .up)
            sleep(3)
            
            // 点赞
            try commander.tap(with: CGPoint(x: 349, y: 447))
        } catch let error {
            print(error.localizedDescription)
        }
     
        print("脚本执行完毕!!!!!!")
    }
}
