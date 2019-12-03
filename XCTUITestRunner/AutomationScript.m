//
// AutomationScript.m
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/12.
// Copyright © 2019 Facebook. All rights reserved.
//


#import "AutomationScript.h"
#import <WebDriverAgentLib/WebDriverAgentLibPublicHeader.h>
#import "RTAppUtils.h"

//#import <MobileAutomationLib/MobileAutomationLib.h>

static NSString *screenshotDirectory() {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths.firstObject;
  return [documentsDirectory stringByAppendingPathComponent:@"screenshot"];
}



@interface AutomationScript ()

@property (nonatomic, strong) RTCommander *commander;
//@property (nonatomic, strong) TouchOpt *opt;

@end

@implementation AutomationScript

- (instancetype)init
{
  self = [super init];
  if (self) {
    NSFileManager *fm= [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if(![fm fileExistsAtPath:screenshotDirectory() isDirectory:&isDirectory] || !isDirectory){
      [fm createDirectoryAtPath:screenshotDirectory() withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:screenshotDirectory() error:nil];
    NSLog(@"屏幕截图:%@", contents);
  }
  return self;
}

- (void)start {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [self.commander unlockWithError:nil];
    [self testShenDiaoXiaLv];
    
//    [self testTapSuspensionButton];
    
//    [self testFillTextForPerfrctGame];
    
//    [self.opt readyServer];
    
    
    
  });
}

// 点击完美世界游戏左侧的悬浮窗，完美世界游戏左侧的悬浮窗都是一样的
- (void)testTapSuspensionButton {
  // 完美世界的游戏左侧都有一个悬浮圆按钮，label为common toolbar icon normal，类型为Button
  XCUIElement *element = [self.commander findElementsWithClassName:@"Button" name:nil label:@"common toolbar icon normal"].firstObject;
  [element tap];
  sleep(3.0);
  
  if (element == nil) {
    // 如果不存在，通过坐标点击
    // 弹出小圆球
    [self.commander tapWithPoint:CGPointMake(50, 115) error:nil];
    sleep(3.0);
  }
  
  NSLog(@"点击完美世界游戏左侧的悬浮窗脚本执行完成");
}

- (void)findScreenPoint {
  CGFloat offsetY = 100.0;
  while (offsetY < [self.commander getWindowSize].height * 0.5) {
    [self.commander tapWithPoint:CGPointMake(50, offsetY) error:nil];
    sleep(3.0);
    offsetY += (CGFloat)10.0;
  }
}

- (void)testFillTextForPerfrctGame {
  sleep(3.0);
  [self.commander setElementText:@"18810181988" forClassName:@"StaticText" name:@"请输入手机号码" error:nil];
  NSLog(@"测试添加完美世界系列游戏脚本执行完毕!");
}

- (void)testShenDiaoXiaLv {
  
  // 测试神雕侠侣2 登录功能
  
  NSString *bundleId = @"com.pwrd.sdxl2.ios";
  
  [self.commander terminateAppWithBundleId:bundleId];
  
  sleep(3.0);
  
  [self.commander launchAppWithBundleId:bundleId];
  
  sleep(5.0);
  
  // 可能有屏幕动画, 点击屏幕任意位置跳过
  [self.commander tapWithPoint:CGPointMake(30, 30) error:nil];
  
  sleep(5.0);

  {
    XCUIElement *loginElement = nil;
    NSInteger retryCount = 5;
    while (!loginElement && retryCount > 0) {
      // 可能有屏幕动画, 点击屏幕任意位置跳过
      [self.commander tapWithPoint:CGPointMake(30, 30) error:nil];
      sleep(3.0);
      loginElement = [self.commander findElementsWithClassName:nil name:@"登 录" label:nil].firstObject;
      retryCount--;
    }
    
    if (!loginElement) {
      // 可能用户已经登录，切换账号退出登录
      // 弹出小圆球
      [self.commander tapWithPoint:CGPointMake(50, 115) error:nil];
      sleep(3.0);
      
      // 点击账号
      XCUIElement *accountElement = [self.commander findElementsWithClassName:nil name:@"账号" label:nil].firstObject;
      [accountElement tap];
      // 点击账号
//      [self tapWithPoint:CGPointMake(85, 115) error:nil];
      sleep(3.0);
      
      [self.commander screenshotWithDirectory:nil fileName:[RTAppUtils genIdentifier] error:nil];
      sleep(3.0);
      
      // 点击切换账号
      XCUIElement *switchAccountElement = [self.commander findElementsWithClassName:nil name:@"切换账号" label:nil].firstObject;
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
//      CGPoint datePoint = CGPointMake(screenPoint.x + relativeCoordinate.x, screenPoint.y + relativeCoordinate.y);
//      [self.commander tapWithPoint:datePoint error:nil];
//      sleep(3.0);
      
      XCUIElement *dateElement = [self.commander findElementsWithClassName:nil name:[RTAppUtils monthAndDay] label:nil].firstObject;
      XCUICoordinate *dateCoordinate = [dateElement coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
      CGPoint dateElementScreenPoint = dateCoordinate.screenPoint;
      NSLog(@"dateElementScreenPoint:%@", NSStringFromCGPoint(dateElementScreenPoint));
      // dateElementScreenPoint:{195.5, 248.5}
      [dateElement tap];
      sleep(5.0);
      
/*
      CGPoint relativeCoordinate = CGPointMake(0, -40.0);
      XCUICoordinate *startCoordinate = [loginElement coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
      __unused CGPoint screenPoint = startCoordinate.screenPoint;
      CGVector offset = CGVectorMake(relativeCoordinate.x, relativeCoordinate.y);
      XCUICoordinate *dstCoordinate = [startCoordinate coordinateWithOffset:offset];
      [dstCoordinate tap];
      */
      

      
      // 添加新账号
      XCUIElement *addAccountElement = [self.commander findElementsWithClassName:nil name:@"添加新账号" label:nil].firstObject;
      [addAccountElement tap];
      sleep(3.0);
      
      // 填充文本可能会失败, 在确定这个textField存在时, 可多次重试
      NSInteger opCount = 3;
      BOOL isSuccess = NO;
      while (opCount > 0) {
        isSuccess = [self.commander setElementText:@"18810181988" forClassName:@"StaticText" name:@"请输入手机号码" error:nil];
        if (isSuccess) {
          opCount = 0;
        }
        sleep(2.0);
        opCount--;
      }
      sleep(3.0);
      
      if (isSuccess == YES) {
        XCUIElement *nextElement = [self.commander findElementsWithClassName:nil name:@"下一步" label:nil].firstObject;
        [nextElement tap];
        sleep(3.0);
        
        
        if (nextElement) {
          
          // 填充文本可能会失败, 在确定这个textField存在时, 可多次重试
               opCount = 3;
               isSuccess = NO;
               while (opCount > 0) {
                 isSuccess = [self.commander setElementText:@"yang308719\n" forClassName:@"StaticText" name:@"请输入您的密码" error:nil];
                 if (isSuccess) {
                   opCount = 0;
                 }
                 sleep(2.0);
                 opCount--;
               }
               sleep(3.0);
          
          if (isSuccess) {
            loginElement = [self.commander findElementsWithClassName:nil name:@"登录" label:nil].firstObject;
            [loginElement tap];
            sleep(3.0);
            
            if (loginElement) {
              // 登录完成后, 退出登录
              
              // 点击左侧圆球
              [self.commander tapWithPoint:CGPointMake(50, 150) error:nil];
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

- (void)testScroll {
 [self.commander swipeFromPoint:CGPointMake(100, 280) toPoint:CGPointMake(300, 280) duration:10.0 error:nil];
  [self.commander swipeFromPoint:CGPointMake(300, 280) toPoint:CGPointMake(100, 280) duration:10.0 error:nil];
  sleep(5.0);
}

- (void)testFindElements {
  
  // 测试有剪切板时是否跳转到聊天页
  [self.commander setPasteboard:@"Today test" contentType:RTPasteBoardContentTypePlaintext error:nil];
  
//  NSString *pasteText = [self getPasteboardWithContentType:RTPasteBoardContentTypePlaintext error:nil];
//  NSLog(@"pasteText:%@", pasteText);
  
  [self.commander terminateAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  sleep(3.0);
  
  [self.commander launchAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  sleep(10.0);
  CGSize size = [self.commander getWindowSize];
  {
    // 如果有立即搜索将消息带到聊天页
    XCUIElement *element = [self.commander findElementsWithClassName:nil name:@"立即搜索" label:nil].firstObject;
    if (element) {
      [element tap];
      sleep(5.0);
      
      // 滑动聊天列表
      int64_t count = 0;
      while (count <= 3) {
        [self.commander swipeWithDirection:RTSwipedirectionDown error:nil];
        sleep(2.0);
        count++;
      }
      
      // 填充文本, 加入\n执行键盘下一步[发布]
      [self.commander setElementText:@"你好, 我是自动化脚本专员小猫, 很高兴为您服务\n" forClassName:@"TextView" name:nil error:nil];
      sleep(3.0);
      
      // 返回
      [self.commander tapWithPoint:CGPointMake(30.0, 55) error:nil];
    }
//    XCUIElement *cancelElement = [self findElementsWithName:@"取消"].firstObject;
//    [cancelElement tap];
//    sleep(5.0);
  }
  {
    // 进入到超级导航页
    [self.commander tapWithPoint:CGPointMake(120.0, size.height - 45) error:nil];
    sleep(3.0);
  }
  
  {
    // 检测是否在首页
    XCUIElement *element = [self.commander findElementsWithClassName:nil name:@"扫一扫" label:nil].firstObject;
    if (!element) {
      // 如果不在首页则点击进入首页
      [self.commander tapWithPoint:CGPointMake(30.0, size.height - 45) error:nil];
      sleep(5.0);
    }
  }
  
  {
    
    // 进入搜索页
    XCUIElement *element = [self.commander findElementsWithClassName:nil name:@" 搜索商品名称/淘宝宝贝标题" label:nil].firstObject;
    [element tap];
    sleep(5.0);
  }
  
  {
    // 填充文本, 加入\n执行键盘下一步[搜索]
    [self.commander setElementText:@"苹果手机\n" forClassName:@"TextField" name:nil error:nil];
    sleep(6.0);
    
    // 滑动搜索页列表
    int64_t count = 0;
    while (count <= 3) {
      [self.commander swipeWithDirection:RTSwipedirectionUp error:nil];
      sleep(2.0);
      count++;
    }
    
    // 从搜索页返回
    [self.commander tapWithPoint:CGPointMake(30, 55) error:nil];
    sleep(3.0);
    
    NSString *fileName = [RTAppUtils genIdentifier];
    [self.commander screenshotWithDirectory:nil fileName:[NSString stringWithFormat:@"%@.png", fileName] error:nil];
    
  }
  
  NSLog(@"喜乐排行app测试脚本执行完毕");
}


- (void)testDismissAlert {
  NSString *alertText = [self.commander getAlertText];
  NSLog(@"%@", alertText);
  sleep(3.0);
  
  [self.commander dismissOkAlertWithError:nil];
}

- (void)testFillText {
  
}

- (void)testScript {
  int count = 0;
  while (count <= 2) {
    [self.commander swipeWithDirection:RTSwipedirectionLeft error:nil];
    sleep(2.0);
    [self.commander swipeWithDirection:RTSwipedirectionRight error:nil];
    sleep(2.0);
    [self.commander tapWithPoint:CGPointMake(50.0, 186) error:nil];
    sleep(3.0);
    [self.commander tapWithPoint:CGPointMake(100.0, 186) error:nil];
    
    NSString *fileName = [RTAppUtils genIdentifier];
    [self.commander screenshotWithDirectory:nil fileName:[NSString stringWithFormat:@"%@.png", fileName] error:nil];
    
    count++;
  }
  // 启动app
  [self.commander launchAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  sleep(3);
  
  [self.commander terminateAppWithBundleId:@"com.ruiteng.ReappearanceApp"];
  
  [self.commander launchAppWithBundleId:@"com.fenxiangjia.nplus"];
  
  // 回到主屏幕
  [self.commander goHomeScreenWithError:nil];
  
  NSLog(@"脚本执行完毕");
}

- (void)testHttpConnection {
    // XCUITest的project中无http及https的能力, 可通过在iOS设备中设置网络代理的方式实现网络请求
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

- (RTCommander *)commander {
  if (!_commander) {
    _commander = [RTCommander new];
  }
  return _commander;
}

//- (TouchOpt *)opt {
//  if (!_opt) {
//    _opt = [TouchOpt new];
//  }
//  return _opt;
//}

@end
