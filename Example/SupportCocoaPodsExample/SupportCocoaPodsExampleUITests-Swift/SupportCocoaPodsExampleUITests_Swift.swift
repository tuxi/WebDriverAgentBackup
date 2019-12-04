////
// SupportCocoaPodsExampleUITests_Swift.swift
// SupportCocoaPodsExample
//
// Created by xiaoyuan on 2019/12/4.
// Copyright © 2019 寻宝天行. All rights reserved.
//

import XCTest
import WebDriverAgentLib

class SupportCocoaPodsExampleUITests_Swift: FBFailureProofTestCase {

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
        webServer.didStartServerBlock = {
            
        }
        webServer.startServing()
    }
}

extension SupportCocoaPodsExampleUITests_Swift: FBWebServerDelegate {
    func webServerDidRequestShutdown(_ webServer: FBWebServer) {
        webServer.stopServing()
    }
}
