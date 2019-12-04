//
// SupportCocoaPodsExampleUITests.m
// SupportCocoaPodsExample
//
// Created by xiaoyuan on 2019/12/4.
// Copyright © 2019 寻宝天行. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WebDriverAgentLibPublicHeader.h>

@interface SupportCocoaPodsExampleUITests : FBFailureProofTestCase <FBWebServerDelegate>

@end

@implementation SupportCocoaPodsExampleUITests

+ (void)setUp {
    [FBDebugLogDelegateDecorator decorateXCTestLogger];
    [FBConfiguration disableRemoteQueryEvaluation];
    [FBConfiguration configureDefaultKeyboardPreferences];
    [super setUp];
}

/**
 Never ending test used to start WebDriverAgent
 */
- (void)testRunner
{
  FBWebServer *webServer = [[FBWebServer alloc] init];
  webServer.delegate = self;
  webServer.didStartServerBlock = ^{
   
  };
  [webServer startServing];
  NSLog(@"");
}

#pragma mark - FBWebServerDelegate

- (void)webServerDidRequestShutdown:(FBWebServer *)webServer
{
  [webServer stopServing];
}

@end
