////
// DouyinAppUITests.swift
// DouyinApp
//
// Created by xiaoyuan on 2019/12/24.
// Copyright © 2019 寻宝天行. All rights reserved.
//

import XCTest
import WebDriverAgentLib

class DouyinAppUITests: FBFailureProofTestCase {
    
    override class func setUp() {
        FBDebugLogDelegateDecorator.decorateXCTestLogger()
        FBConfiguration.disableRemoteQueryEvaluation()
        FBConfiguration.configureDefaultKeyboardPreferences()
        super.setUp()
    }
    
    /**
     Never ending test used to start WebDriverAgent
     */
    func testRunner() {
        let webServer = FBWebServer()
        webServer.delegate = self
        webServer.startServing {
            AutomationScript().start()
        }
    }
}

extension DouyinAppUITests: FBWebServerDelegate {
    func webServerDidRequestShutdown(_ webServer: FBWebServer) {
        webServer.stopServing()
    }
}
