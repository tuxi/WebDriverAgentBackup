//
// AutomationScript.m
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/12.
// Copyright © 2019 Facebook. All rights reserved.
//


#import "AutomationScript.h"
#import <WebDriverAgentLib/FBMathUtils.h>
#import <WebDriverAgentLib/NSPredicate+FBFormat.h>
#import <WebDriverAgentLib/XCUICoordinate.h>
#import <WebDriverAgentLib/XCUIDevice.h>
#import <WebDriverAgentLib/XCUIElement+FBIsVisible.h>
#import "XCUIElement+FBPickerWheel.h"
#import <WebDriverAgentLib/XCUIElement+FBScrolling.h>
#import <WebDriverAgentLib/XCUIElement+FBTap.h>
#import <WebDriverAgentLib/XCUIElement+FBForceTouch.h>
#import <WebDriverAgentLib/XCUIElement+FBTyping.h>
#import <WebDriverAgentLib/XCUIElement+FBUtilities.h>
#import <WebDriverAgentLib/XCUIElement+FBWebDriverAttributes.h>
#import "XCUIElement+FBTVFocuse.h"
#import <WebDriverAgentLib/FBElementTypeTransformer.h>
#import <WebDriverAgentLib/XCUIElement.h>
#import <WebDriverAgentLib/XCUIElementQuery.h>
#import <WebDriverAgentLib/FBRuntimeUtils.h>
#import <WebDriverAgentLib/FBXCodeCompatibility.h>
#import "RTAppUtils.h"
#import "XCUIElement+FBClassChain.h"
#import "FBPredicate.h"
#import "FBPasteboard.h"
#import "RTElementSelector.h"

static NSString *screenshotDirectory() {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths.firstObject;
  return [documentsDirectory stringByAppendingPathComponent:@"screenshot"];
}



@interface AutomationScript ()

@property (nonatomic, copy) NSString *defaultActiveApplication;
@property (nonatomic) NSDictionary<NSString *, FBApplication *> *applications;

@end

@implementation AutomationScript

- (instancetype)init
{
  self = [super init];
  if (self) {
    NSFileManager *fm= [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:screenshotDirectory()]){
      [fm createDirectoryAtPath:screenshotDirectory() withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:screenshotDirectory() error:nil];
    NSLog(@"屏幕截图:%@", contents);
  }
  return self;
}

- (void)start {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [self unlockWithError:nil];
    

//    [self testShenDiaoXiaLv];
    
    FBApplication *app = [FBSession activeSession].activeApplication;
    NSLog(@"%@", app);
    
    [self testTapSuspensionButton];
    
//    [self testFillTextForPerfrctGame];
    
  });
}

// 点击完美世界游戏左侧的悬浮窗，完美世界游戏左侧的悬浮窗都是一样的
- (void)testTapSuspensionButton {
  // 完美世界的游戏左侧都有一个悬浮圆按钮，label为common toolbar icon normal，类型为Button
  XCUIElement *element = [self findElementsWithClassName:@"Button" name:nil label:@"common toolbar icon normal"].firstObject;
  [element tap];
  sleep(3.0);
  
  if (element == nil) {
    // 如果不存在，通过坐标点击
    // 弹出小圆球
    [self tapWithPoint:CGPointMake(50, 115) error:nil];
    sleep(3.0);
  }
  
  NSLog(@"点击完美世界游戏左侧的悬浮窗脚本执行完成");
}

- (void)findScreenPoint {
  CGFloat offsetY = 100.0;
  while (offsetY < [self getWindowSize].height * 0.5) {
    [self tapWithPoint:CGPointMake(50, offsetY) error:nil];
    sleep(3.0);
    offsetY += (CGFloat)10.0;
  }
}

- (void)testFillTextForPerfrctGame {
  sleep(3.0);
  [self setElementText:@"18810181988" forClassName:@"StaticText" name:@"请输入手机号码" error:nil];
  NSLog(@"测试添加完美世界系列游戏脚本执行完毕!");
}

- (void)testShenDiaoXiaLv {
  
  // 测试神雕侠侣2 登录功能
  
  NSString *bundleId = @"com.pwrd.sdxl2.ios";
  
  [self terminateAppWithBundleId:bundleId];
  
  sleep(3.0);
  
  [self launchAppWithBundleId:bundleId];
  
  sleep(5.0);
  
  // 可能有屏幕动画, 点击屏幕任意位置跳过
  [self tapWithPoint:CGPointMake(30, 30) error:nil];
  
  sleep(5.0);

//  {
//    XCUIElement *element = [self findElementsWithName:@"点击选服"].firstObject;
//    [element tap];
//  }
  {
    XCUIElement *loginElement = nil;
    NSInteger retryCount = 5;
    while (!loginElement && retryCount > 0) {
      // 可能有屏幕动画, 点击屏幕任意位置跳过
      [self tapWithPoint:CGPointMake(30, 30) error:nil];
      sleep(3.0);
      loginElement = [self findElementsWithClassName:nil name:@"登 录" label:nil].firstObject;
      retryCount--;
    }
    
    if (!loginElement) {
      // 可能用户已经登录，切换账号退出登录
      // 弹出小圆球
      [self tapWithPoint:CGPointMake(50, 115) error:nil];
      sleep(3.0);
      
      // 点击账号
      XCUIElement *accountElement = [self findElementsWithClassName:nil name:@"账号" label:nil].firstObject;
      [accountElement tap];
      // 点击账号
//      [self tapWithPoint:CGPointMake(85, 115) error:nil];
      sleep(3.0);
      
      // 点击切换账号
      XCUIElement *switchAccountElement = [self findElementsWithClassName:nil name:@"切换账号" label:nil].firstObject;
      [switchAccountElement tap];
      sleep(3.0);
      
      if (switchAccountElement) {
        // 切换完成账号后，重新执行脚本
        [self testShenDiaoXiaLv];
        return;
      }
      
    }
    
    if (loginElement) {
      // 切换账号
      // 根据某个元素获取他周边的元素坐标, 并执行点击
//      XCUICoordinate *loginCoordinate = [loginElement coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
//      CGPoint relativeCoordinate = CGPointMake(50.0, -140.0);
//      CGPoint screenPoint = loginCoordinate.screenPoint;
//      // 计算账号按钮的坐标
//      CGPoint accountPoint = CGPointMake(screenPoint.x + relativeCoordinate.x, screenPoint.y + relativeCoordinate.y);
//      [self tapWithPoint:accountPoint error:nil];
      
//      CGPoint relativeCoordinate = CGPointMake(0, -40.0);
//      XCUICoordinate *startCoordinate = [loginElement coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
//      __unused CGPoint screenPoint = startCoordinate.screenPoint;
//      CGVector offset = CGVectorMake(relativeCoordinate.x, relativeCoordinate.y);
//      XCUICoordinate *dstCoordinate = [startCoordinate coordinateWithOffset:offset];
//      [dstCoordinate tap];
      
      XCUIElement *dateElement = [self findElementsWithClassName:nil name:@"11/14" label:nil].firstObject;
      XCUICoordinate *dateCoordinate = [dateElement coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
      CGPoint dateElementScreenPoint = dateCoordinate.screenPoint;
      NSLog(@"dateElementScreenPoint:%@", NSStringFromCGPoint(dateElementScreenPoint));
      // dateElementScreenPoint:{195.5, 248.5}
      [dateElement tap];
      sleep(5.0);
      
      // 添加新账号
      XCUIElement *addAccountElement = [self findElementsWithClassName:nil name:@"添加新账号" label:nil].firstObject;
      [addAccountElement tap];
      sleep(3.0);
      
      // 输入手机号
      FBApplication *app = [FBSession activeSession].activeApplication;
      NSLog(@"%@", app);
      
      
      
      // 填充文本可能会失败, 在确定这个textField存在时, 可多次重试
      NSInteger opCount = 3;
      BOOL isSuccess = NO;
      while (opCount > 0) {
        isSuccess = [self setElementText:@"18810181988" forClassName:@"StaticText" name:@"请输入手机号码" error:nil];
        if (isSuccess) {
          opCount = 0;
        }
        sleep(2.0);
        opCount--;
      }
      sleep(3.0);
      
      if (isSuccess == YES) {
        XCUIElement *nextElement = [self findElementsWithClassName:nil name:@"下一步" label:nil].firstObject;
        [nextElement tap];
        sleep(3.0);
        
        
        if (nextElement) {
          
          // 填充文本可能会失败, 在确定这个textField存在时, 可多次重试
               opCount = 3;
               isSuccess = NO;
               while (opCount > 0) {
                 isSuccess = [self setElementText:@"yang308719\n" forClassName:@"StaticText" name:@"请输入您的密码" error:nil];
                 if (isSuccess) {
                   opCount = 0;
                 }
                 sleep(2.0);
                 opCount--;
               }
               sleep(3.0);
          
          if (isSuccess) {
            loginElement = [self findElementsWithClassName:nil name:@"登录" label:nil].firstObject;
            [loginElement tap];
            sleep(3.0);
            
            if (loginElement) {
              // 登录完成后, 退出登录
              
              // 点击左侧圆球
              [self tapWithPoint:CGPointMake(50, 150) error:nil];
            }
            
          }
          
        }
        
      }
      
    }
  }
  
//  {
//    XCUIElement *element = [self findElementsWithName:@"切换账号"].firstObject;
//    [element tap];
//  }
  
  NSLog(@"神雕侠侣测试脚本执行完毕");
}

- (void)testFindElements {
  
  // 测试有剪切板时是否跳转到聊天页
  [self setPasteboard:@"Today test" contentType:RTPasteBoardContentTypePlaintext error:nil];
  
//  NSString *pasteText = [self getPasteboardWithContentType:RTPasteBoardContentTypePlaintext error:nil];
//  NSLog(@"pasteText:%@", pasteText);
  
  [self terminateAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  sleep(3.0);
  
  [self launchAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  sleep(10.0);
  CGSize size = [self getWindowSize];
  {
    // 如果有立即搜索将消息带到聊天页
    XCUIElement *element = [self findElementsWithClassName:nil name:@"立即搜索" label:nil].firstObject;
    if (element) {
      [element tap];
      sleep(5.0);
      
      // 滑动聊天列表
      int64_t count = 0;
      while (count <= 3) {
        [self swipeWithDirection:RTSwipedirectionDown error:nil];
        sleep(2.0);
        count++;
      }
      
      // 填充文本, 加入\n执行键盘下一步[发布]
      [self setElementText:@"你好, 我是自动化脚本专员小猫, 很高兴为您服务\n" forClassName:@"TextView" name:nil error:nil];
      sleep(3.0);
      
      // 返回
      [self tapWithPoint:CGPointMake(30.0, 55) error:nil];
    }
//    XCUIElement *cancelElement = [self findElementsWithName:@"取消"].firstObject;
//    [cancelElement tap];
//    sleep(5.0);
  }
  {
    // 进入到超级导航页
    [self tapWithPoint:CGPointMake(120.0, size.height - 45) error:nil];
    sleep(3.0);
  }
  
  {
    // 检测是否在首页
    XCUIElement *element = [self findElementsWithClassName:nil name:@"扫一扫" label:nil].firstObject;
    if (!element) {
      // 如果不在首页则点击进入首页
      [self tapWithPoint:CGPointMake(30.0, size.height - 45) error:nil];
      sleep(5.0);
    }
  }
  
  {
    
    // 进入搜索页
    XCUIElement *element = [self findElementsWithClassName:nil name:@" 搜索商品名称/淘宝宝贝标题" label:nil].firstObject;
    [element tap];
    sleep(5.0);
  }
  
  {
    // 填充文本, 加入\n执行键盘下一步[搜索]
    [self setElementText:@"苹果手机\n" forClassName:@"TextField" name:nil error:nil];
    sleep(6.0);
    
    // 滑动搜索页列表
    int64_t count = 0;
    while (count <= 3) {
      [self swipeWithDirection:RTSwipedirectionUp error:nil];
      sleep(2.0);
      count++;
    }
    
    // 从搜索页返回
    [self tapWithPoint:CGPointMake(30, 55) error:nil];
    sleep(3.0);
    
    [self screenshotWithError:nil];
    
  }
  
  NSLog(@"喜乐排行app测试脚本执行完毕");
}

- (void)testDismissAlert {
  NSString *alertText = [self getAlertText];
  NSLog(@"%@", alertText);
  sleep(3.0);
  
  [self dismissOkAlertWithError:nil];
}

- (void)testFillText {
  
}

- (void)testScript {
  int count = 0;
  while (count <= 2) {
    [self swipeWithDirection:RTSwipedirectionLeft error:nil];
    sleep(2.0);
    [self swipeWithDirection:RTSwipedirectionRight error:nil];
    sleep(2.0);
    [self tapWithPoint:CGPointMake(50.0, 186) error:nil];
    sleep(3.0);
    [self tapWithPoint:CGPointMake(100.0, 186) error:nil];
    
    [self screenshotWithError:nil];
    
    count++;
  }
  // 启动app
  [self launchAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  sleep(3);
  
  [self terminateAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  [self launchAppWithBundleId:@"com.fenxiangjia.nplus"];
  
  // 回到主屏幕
  [self goHomeScreenWithError:nil];
  
  NSLog(@"脚本执行完毕");
}

- (BOOL)swipeWithDirection:(RTSwipedirection)direction error:(NSError * _Nullable *)error {
  XCUIElement *element = [FBSession activeSession].activeApplication;
  if (direction == RTSwipedirectionUp) {
    [element swipeUp];
  } else if (direction == RTSwipedirectionDown) {
    [element swipeDown];
  } else if (direction == RTSwipedirectionLeft) {
    [element swipeLeft];
  } else if (direction == RTSwipedirectionRight) {
    [element swipeRight];
  } else {
    if (error) {
      *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"无效的参数direction"}];
    }
    return NO;
  }
  return YES;
}

- (BOOL)screenshotWithError:(NSError * _Nullable *)error
{
  XCUIElement *element = [FBSession activeSession].activeApplication;
  NSError *screenShotError;
  NSData *screenshotData = [element fb_screenshotWithError:&screenShotError];
  if (screenShotError) {
    if (error) {
      *error = screenShotError;
    }
    return NO;
  }
  NSString *directory = screenshotDirectory();
  BOOL flag = [screenshotData writeToFile:[directory stringByAppendingPathComponent:@"screentshot.png"] atomically:YES];
  if (flag) {
    NSLog(@"文件写入成功");
  }
//  NSString *screenshot = [screenshotData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
  return YES;
}

- (BOOL)tapWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable *)error {
  XCUIElement *element = [FBSession activeSession].activeApplication;
  if (nil == element) {
    XCUICoordinate *tapCoordinate = [self.class gestureCoordinateWithCoordinate:tapPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
    [tapCoordinate tap];
  } else {
    NSError *error1;
    if (![element fb_tapCoordinate:tapPoint error:&error1]) {
      if (error) {
        *error = error1;
      }
      NSLog(@"%@", error1);
      return NO;
    }
  }
  return YES;
}

- (BOOL)clickWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable *)error {
  XCUIElement *element = [FBSession activeSession].activeApplication;
  if (nil == element) {
    if (error) {
      *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"element is nil!"}];
    }
    return NO;
  }
#if TARGET_OS_IOS
  if (![element fb_tapWithError:error]) {
#elif TARGET_OS_TV
    if (![element fb_selectWithError:error]) {
#endif
      return NO;
    }
    return YES;
  }

- (void)launchAppWithBundleId:(NSString *)bundleIdentifier {
  if (bundleIdentifier.length == 0) {
    return;
  }
  [[FBSession activeSession] launchApplicationWithBundleId:bundleIdentifier shouldWaitForQuiescence:nil arguments:nil environment:nil];
}

- (void)terminateAppWithBundleId:(NSString *)bundleIdentifier {
  if (bundleIdentifier.length == 0) {
    return;
  }
  [[FBSession activeSession] terminateApplicationWithBundleId:bundleIdentifier];
}

- (BOOL)lockWithError:(NSError * _Nullable __autoreleasing *)error {
  NSError *lockError;
  if (![[XCUIDevice sharedDevice] fb_lockScreen:&lockError]) {
    if (error) {
      *error = lockError;
    }
    return NO;
  }
  return YES;
}

- (BOOL)deactivateppWithBundleId:(NSString *)bundleIdentifier duration:(NSTimeInterval)duration error:(NSError * _Nullable __autoreleasing *)error
{
  const static NSTimeInterval FBMinimumAppSwitchWait = 3.0;
  if(![self goHomeScreenWithError:error]) {
    return NO;
  }
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:MAX(duration, FBMinimumAppSwitchWait)]];
  [self launchAppWithBundleId:bundleIdentifier];
  return YES;
}

- (BOOL)unlockWithError:(NSError * _Nullable __autoreleasing *)error {
  NSError *unlockError;
  if (![[XCUIDevice sharedDevice] fb_unlockScreen:&unlockError]) {
    if (error) {
      *error = unlockError;
    }
    return NO;
  }
  return YES;
}

- (NSDictionary *)getActiveApp {
  XCUIApplication *app = [FBSession activeSession].activeApplication ?: FBApplication.fb_activeApplication;
  return @{
    @"pid": @(app.processID),
    @"bundleId": app.bundleID,
    @"name": app.identifier,
    @"processArguments": [self.class processArguments:app],
  };
}


+ (NSDictionary *)processArguments:(XCUIApplication *)app
{
  // Can be nil if no active activation is defined by XCTest
  if (app == nil) {
    return @{};
  }

  return
  @{
    @"args": app.launchArguments,
    @"env": app.launchEnvironment
  };
}

- (BOOL)goHomeScreenWithError:(NSError * _Nullable __autoreleasing *)error
{
  NSError *error1;
  if (![[XCUIDevice sharedDevice] fb_goToHomescreenWithError:&error1]) {
    if (error) {
      *error = error1;
    }
    return NO;
  }
  return YES;
}

- (BOOL)hideKeyboardWithError:(NSError * _Nullable __autoreleasing *)error
{
#if TARGET_OS_TV
  if ([self isKeyboardPresentForApplication:request.session.activeApplication]) {
    [[XCUIRemote sharedRemote] pressButton: XCUIRemoteButtonMenu];
  }
#else
  [[FBSession activeSession].activeApplication dismissKeyboard];
#endif
  NSError *error1;
  NSString *errorDescription = @"The keyboard cannot be dismissed. Try to dismiss it in the way supported by your application under test.";
  if ([UIDevice.currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    errorDescription = @"The keyboard on iPhone cannot be dismissed because of a known XCTest issue. Try to dismiss it in the way supported by your application under test.";
  }
  BOOL isKeyboardNotPresent =
  [[[[FBRunLoopSpinner new]
     timeout:5]
    timeoutErrorMessage:errorDescription]
   spinUntilTrue:^BOOL{
     return ![self isKeyboardPresentForApplication:[FBSession activeSession].activeApplication];
   }
   error:&error1];
  if (!isKeyboardNotPresent) {
    if (error) {
      *error = error1;
    }
    NSLog(@"%@", NSThread.callStackSymbols);
    return NO;
  }
  return YES;
}

- (void)doubleTapWithPoint:(CGPoint)point
{
  CGPoint doubleTapPoint = point;
  XCUICoordinate *doubleTapCoordinate = [self.class gestureCoordinateWithCoordinate:doubleTapPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
  [doubleTapCoordinate doubleTap];
}

- (NSArray<NSString *> *)getAlertButtons
{
  
  FBSession *session = [FBSession activeSession];
  FBAlert *alert = [FBAlert alertWithApplication:session.activeApplication];

  if (!alert.isPresent) {
    return nil;
  }
  NSArray *labels = alert.buttonLabels;
  return labels;
}

- (FBAlert *)getCurrentAlert {
  FBSession *session = [FBSession activeSession];
  FBAlert *alert = [FBAlert alertWithApplication:session.activeApplication];
  return alert;
}

- (BOOL)dismissOkAlertWithError:(NSError * _Nullable __autoreleasing *)error {
  FBAlert *alert = [self getCurrentAlert];
  NSArray *buttonLabels = alert.buttonLabels;
  
  if (buttonLabels.count == 0) {
    if (error) {
      *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"当前页面没有弹框"}];
    }
    return NO;
  }
  NSArray<NSString *> *okTitles = @[@"不再提醒", @"OK", @"知道了", @"好", @"Allow", @"立即搜索"];
  NSSet *okSet = [NSSet setWithArray:okTitles];
  // 判断是否有交集
  if ([okSet intersectsSet:[NSSet setWithArray:buttonLabels]]) {
    NSError *dismissError = nil;
    if (![alert clickAlertButton:(NSString *)okTitles.firstObject error:&dismissError]) {
      if (error) {
        *error = dismissError;
      }
      return NO;
    }
    return YES;
  }
  return NO;
}

- (NSString *_Nullable)getAlertText {
  FBSession *session = [FBSession activeSession];
  NSString *alertText = [FBAlert alertWithApplication:session.activeApplication].text;
  return alertText;
}

+ (id<FBResponsePayload>)handleAlertGetTextCommand:(FBRouteRequest *)request
{
  FBSession *session = request.session;
  NSString *alertText = [FBAlert alertWithApplication:session.activeApplication].text;
  if (!alertText) {
    return FBResponseWithStatus([FBCommandStatus noAlertOpenErrorWithMessage:nil
                                                                   traceback:nil]);
  }
  return FBResponseWithObject(alertText);
}

//static void cachedElements(NSArray<XCUIElement *> *elements, FBElementCache *elementCache, BOOL compact)
//{
//  NSMutableArray *elementsResponse = [NSMutableArray array];
//  for (XCUIElement *element in elements) {
//    NSString *elementUUID = [elementCache storeElement:element];
//    [elementsResponse addObject:FBDictionaryResponseWithElement(element, elementUUID, compact)];
//  }
//}



/// 根据UI元素的文本获取UI元素
//- (NSArray<XCUIElement *> * _Nullable)findElementsWithText:(NSString *)text {
//  return [self findElementsWithClassName:@"Any" WithValue:text];
//}

- (NSArray<XCUIElement *>  *)findsElementsUsing:(RTElementUsingType)usingType withValue:(NSString *)value {
  NSArray *elements = [self.class elementsUsing:usingType
                                      withValue:value];
  // 缓存查找的元素
//  cachedElements(elements, session.elementCache, FBConfiguration.shouldUseCompactResponses);
  return elements;
}


/// 根据UI元素的className获取UI元素
/// @param className 要查找的类名
/// @param name 控件的名称，比如控件的text
/// @param label 比如button 的icon名称 ， 比如完美世界游戏左侧悬浮窗的名称为common toolbar icon normal
- (NSArray<XCUIElement *> * _Nullable)findElementsWithClassName:(NSString *_Nullable)className name:(NSString *_Nullable)name label:(NSString *_Nullable)label {
  RTElementSelector *selector = [[RTElementSelector alloc] init];
  selector.className = className;
  selector.name = name;
  selector.label = label;
//  selector.visible = @1;
//  selector.enabled = @1;
  return [self findElementsWithSelector:selector];
}

- (NSArray<XCUIElement *> * _Nullable)findElementsWithSelector:(RTElementSelector *_Nullable)selector {
  
  RTFindElementParamter *parmater = [selector genFindElementParmter];
  return [self findsElementsUsing:parmater.usingType withValue:parmater.value];
}

/// classNmae 使用static NSArray *kELEMENTTypes() 参照XCUIElementType API
- (NSArray<XCUIElement *> * _Nullable)findElementsWithClassName:(NSString *)className WithValue:(NSString *)value {
  if (className.length > 0 && ![className hasPrefix:@"XCUIElementType"]) {
    className = [NSString stringWithFormat:@"XCUIElementType%@", className];
  }
  if (className.length == 0) {
    className = @"XCUIElementTypeAny";
  }
  return [self findsElementsUsing:@"class chain" withValue:[NSString stringWithFormat:@"**/%@[`name == '%@'`]", className, value]];
}

+ (NSArray<XCUIElement *> * _Nullable)elementsUsing:(RTElementUsingType)usingText withValue:(NSString *)value
{
  // {
  //     using = "class chain";
  //     value = "**/XCUIElementTypeAny[`name == '\U5185\U8863'`]";
  // }
  BOOL shouldReturnAfterFirstMatch = NO;
  XCUIElement *element = [FBSession activeSession].activeApplication;
  NSArray *elements;
  const BOOL partialSearch = [usingText isEqualToString:RTElementUsingTypePartialLinkText];
  const BOOL isSearchByIdentifier = ([usingText isEqualToString:RTElementUsingTypeName] || [usingText isEqualToString:RTElementUsingTypeId] || [usingText isEqualToString:RTElementUsingTypeAccessibilityId]);
  if (partialSearch || [usingText isEqualToString:RTElementUsingTypeLinkText]) {
    NSArray *components = [value componentsSeparatedByString:@"="];
    NSString *propertyValue = components.lastObject;
    NSString *propertyName = (components.count < 2 ? RTElementUsingTypeName : components.firstObject);
    elements = [element fb_descendantsMatchingProperty:propertyName value:propertyValue partialSearch:partialSearch];
  } else if ([usingText isEqualToString:RTElementUsingTypeClassName]) {
    elements = [element fb_descendantsMatchingClassName:value shouldReturnAfterFirstMatch:shouldReturnAfterFirstMatch];
  } else if ([usingText isEqualToString:RTElementUsingTypeClassChain]) {
    elements = [element fb_descendantsMatchingClassChain:value shouldReturnAfterFirstMatch:shouldReturnAfterFirstMatch];
  } else if ([usingText isEqualToString:RTElementUsingTypeXpath]) {
    elements = [element fb_descendantsMatchingXPathQuery:value shouldReturnAfterFirstMatch:shouldReturnAfterFirstMatch];
  } else if ([usingText isEqualToString:RTElementUsingTypePredicateString]) {
    NSPredicate *predicate = [FBPredicate predicateWithFormat:value];
    elements = [element fb_descendantsMatchingPredicate:predicate shouldReturnAfterFirstMatch:shouldReturnAfterFirstMatch];
  } else if (isSearchByIdentifier) {
    elements = [element fb_descendantsMatchingIdentifier:value shouldReturnAfterFirstMatch:shouldReturnAfterFirstMatch];
  } else {
    [[NSException exceptionWithName:FBElementAttributeUnknownException reason:[NSString stringWithFormat:@"Invalid locator requested: %@", usingText] userInfo:nil] raise];
  }
  return elements;
}

/// 给控件添加文本
- (BOOL)setElementText:(NSString *)text forClassName:(NSString *)className name:(NSString *_Nullable)name error:(NSError * _Nullable __autoreleasing *)error
{
  XCUIElement *element = [self findElementsWithClassName:className name:name label:nil].firstObject;
  id value = text;
  if (!value || !element) {
    if (error) {
      *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"Neither 'text' nor 'element' parameter is provided"}];
    }
    return NO;
  }
  NSString *textToType = [value isKindOfClass:NSArray.class]
    ? [value componentsJoinedByString:@""]
    : value;
#if !TARGET_OS_TV
  if (element.elementType == XCUIElementTypePickerWheel) {
    [element adjustToPickerWheelValue:textToType?:@""];
    return YES;
  }
#endif
  if (element.elementType == XCUIElementTypeSlider) {
    CGFloat sliderValue = textToType.floatValue;
    if (sliderValue < 0.0 || sliderValue > 1.0 ) {
      if (error) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"Value of slider should be in 0..1 range"}];
      }
      return NO;
    }
    [element adjustToNormalizedSliderPosition:sliderValue];
    return YES;
  }
  NSUInteger frequency = [FBConfiguration maxTypingFrequency];
  if (![element fb_typeText:textToType?:@"" frequency:frequency error:error]) {
    return NO;
  }
  return YES;
}

#if !TARGET_OS_TV
- (BOOL)setPasteboard:(NSString *)content contentType:(RTPasteBoardContentType)contentType error:(NSError * _Nullable __autoreleasing * _Nullable)error
{
  NSString *contentTypeStr = nil;
  NSData *contentData = nil;
  if (contentType == RTPasteBoardContentTypePlaintext) {
    contentTypeStr = @"plaintext";
    contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
  }
  if (contentType == RTPasteBoardContentTypeImage) {
    contentTypeStr = @"image";
    contentData = [[NSData alloc] initWithBase64EncodedString:content
    options:NSDataBase64DecodingIgnoreUnknownCharacters];
  }
  if (contentType == RTPasteBoardContentTypeURL) {
    contentTypeStr = @"url";
    content = [content stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
  }
  
  if (nil == contentData) {
    if (error) {
      *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"Cannot decode the pasteboard content from base64"}];
    }
    return NO;
  }
  if (![FBPasteboard setData:contentData forType:contentTypeStr error:error]) {
    return NO;
  }
  return YES;
}



- (NSString *_Nullable)getPasteboardWithContentType:(RTPasteBoardContentType)contentType error:(NSError * _Nullable __autoreleasing *)error
{
  NSString *contentTypeStr = nil;
  if (contentType == RTPasteBoardContentTypePlaintext) {
    contentTypeStr = @"plaintext";
  }
  if (contentType == RTPasteBoardContentTypeImage) {
    contentTypeStr = @"image";
  }
  if (contentType == RTPasteBoardContentTypeURL) {
    contentTypeStr = @"url";
  }
  id result = [FBPasteboard dataForType:contentTypeStr error:error];
  if (nil == result) {
    return nil;
  }
  return [result base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#endif

#pragma mark - Helpers

- (CGSize)getWindowSize
{

#if TARGET_OS_TV
  CGSize screenSize = [FBSession activeSession].activeApplication.frame.size;
#else
  CGRect frame = [FBSession activeSession].activeApplication.wdFrame;
  CGSize screenSize = FBAdjustDimensionsForApplication(frame.size, [FBSession activeSession].activeApplication.interfaceOrientation);
#endif
  return screenSize;
}

- (BOOL)isKeyboardPresentForApplication:(XCUIApplication *)application {
  XCUIElement *foundKeyboard = [application.fb_query descendantsMatchingType:XCUIElementTypeKeyboard].fb_firstMatch;
  return foundKeyboard && foundKeyboard.fb_isVisible;
}

+ (XCUICoordinate *)gestureCoordinateWithCoordinate:(CGPoint)coordinate application:(XCUIApplication *)application shouldApplyOrientationWorkaround:(BOOL)shouldApplyOrientationWorkaround
{
  CGPoint point = coordinate;
  if (shouldApplyOrientationWorkaround) {
    point = FBInvertPointForApplication(coordinate, application.frame.size, application.interfaceOrientation);
  }

  /**
   If SDK >= 11, the tap coordinate based on application is not correct when
   the application orientation is landscape and
   tapX > application portrait width or tapY > application portrait height.
   Pass the window element to the method [FBElementCommands gestureCoordinateWithCoordinate:element:]
   will resolve the problem.
   More details about the bug, please see the following issues:
   #705: https://github.com/facebook/WebDriverAgent/issues/705
   #798: https://github.com/facebook/WebDriverAgent/issues/798
   #856: https://github.com/facebook/WebDriverAgent/issues/856
   Notice: On iOS 10, if the application is not launched by wda, no elements will be found.
   See issue #732: https://github.com/facebook/WebDriverAgent/issues/732
   */
  XCUIElement *element = application;
  if (isSDKVersionGreaterThanOrEqualTo(@"11.0")) {
    XCUIElement *window = application.windows.fb_firstMatch;
    if (window) {
      element = window;
      point.x -= element.frame.origin.x;
      point.y -= element.frame.origin.y;
    }
  }
  return [self gestureCoordinateWithCoordinate:point element:element];
}

/**
 Returns gesture coordinate based on the specified element.

 @param coordinate absolute coordinates based on the element
 @param element the element in the current application under test
 @return translated gesture coordinates ready to be passed to XCUICoordinate methods
 */
+ (XCUICoordinate *)gestureCoordinateWithCoordinate:(CGPoint)coordinate element:(XCUIElement *)element
{
  XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:element normalizedOffset:CGVectorMake(0, 0)];
  return [[XCUICoordinate alloc] initWithCoordinate:appCoordinate pointsOffset:CGVectorMake(coordinate.x, coordinate.y)];
}

- (void)testHttpConnection {
    
  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  //
  //
  //    NSURL *url = [NSURL URLWithString:@"http://localhost:8100/wda/locked"];
  //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  //    request.HTTPMethod = @"POST";
  //    //    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"boundary"];
  //    //    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
  //    NSDictionary *paramters = @{@"fromX": @"50.0", @"fromY": @"300.0", @"toX": @"260.0", @"toY": @"260.0"};
  //    //获取字典的所有keys
  //    NSArray * keys = [paramters allKeys];
  //    NSMutableString *parStr = [NSMutableString new];
  //    //拼接字符串
  //    NSInteger count = keys.count;
  //    for (int j = 0; j < count; j ++){
  //      if (j == 0){
  //        [parStr appendString:@"?"];
  //
  //      }
  //      NSString *str = [NSString stringWithFormat:@"&%@=%@", keys[j], paramters[keys[j]]];
  //      [parStr appendString:str];
  //    }
  //    NSData *bodyData = [parStr dataUsingEncoding:NSUTF8StringEncoding];
  //    request.HTTPBody = bodyData;
  //    request.timeoutInterval = 10.0;
  //    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
  //      if (data != nil) {
  //        NSData *d = data;
  //        id responseObj = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingAllowFragments error:nil];
  //        NSLog(@"%@", responseObj);
  //      }
  //    }] resume];
  //  });
}


@end
