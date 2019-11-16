//
// RTAppUtils.m
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/13.
// Copyright © 2019 Facebook. All rights reserved.
//

#import "RTAppUtils.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

@implementation RTAppUtils

// iOS11后无效了
+ (NSArray<NSString *> *)allAppBundleIds {
  NSMutableArray *allID = [[NSMutableArray alloc] init];
  Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSObject* workspace = [LSApplicationWorkspace_class performSelector:NSSelectorFromString(@"defaultWorkspace")];
  NSArray *appArray = [workspace performSelector:NSSelectorFromString(@"allApplications")];
#pragma clang diagnostic pop
  
  NSString *model = [UIDevice currentDevice].model;
  for (NSString *str in appArray) {
    //转换成字符串类型
    NSString *string = [str description];
    NSRange rg1 = [string rangeOfString:@">"];
    string = [string substringFromIndex:rg1.location + 2];
    if ([model isEqualToString:@"iPad"]) {
      NSRange rg2 = [string rangeOfString:@"<"];
      string = [string substringToIndex:rg2.location - 1];
      
    }
    NSDictionary *dic = @{@"bundleID":string};
    [allID addObject:dic];
  }
  return allID;
}


+ (NSDictionary *)getDeviceInfo
{
  // Returns locale like ja_EN and zh-Hant_US. The format depends on OS
  // Developers should use this locale by default
  // https://developer.apple.com/documentation/foundation/nslocale/1414388-autoupdatingcurrentlocale
  NSString *currentLocale = [[NSLocale autoupdatingCurrentLocale] localeIdentifier];

  return @{
      @"currentLocale": currentLocale,
      @"timeZone": self.timeZone,
      @"name": UIDevice.currentDevice.name,
      @"model": UIDevice.currentDevice.model,
      @"uuid": [UIDevice.currentDevice.identifierForVendor UUIDString] ?: @"unknown",
      // https://developer.apple.com/documentation/uikit/uiuserinterfaceidiom?language=objc
      @"userInterfaceIdiom": @(UIDevice.currentDevice.userInterfaceIdiom),
  #if TARGET_OS_SIMULATOR
      @"isSimulator": @(YES),
  #else
      @"isSimulator": @(NO),
  #endif
  };
}

/**
 * @return The string of TimeZone. Returns TZ timezone id by default. Returns TimeZone name by Apple if TZ timezone id is not available.
 */
+ (NSString *)timeZone
{
  NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
  // Apple timezone name like "US/New_York"
  NSString *timeZoneAbb = [localTimeZone abbreviation];
  if (timeZoneAbb == nil) {
    return [localTimeZone name];
  }

  // Convert timezone name to ids like "America/New_York" as TZ database Time Zones format
  // https://developer.apple.com/documentation/foundation/nstimezone
  NSString *timeZoneId = [[NSTimeZone timeZoneWithAbbreviation:timeZoneAbb] name];
  if (timeZoneId != nil) {
    return timeZoneId;
  }

  return [localTimeZone name];
}



+ (NSString *)genIdentifier {
  
  CFUUIDRef uuidRef =CFUUIDCreate(NULL);
  
  CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
  
  NSString *uniqueId = (__bridge NSString *)(uuidStringRef);
  if (uuidStringRef) {
    CFBridgingRelease(uuidStringRef);    
  }
  return uniqueId;
  
}

+ (NSString *)monthAndDay {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM/dd"];
  return [dateFormatter stringFromDate:[NSDate date]];
}



@end

