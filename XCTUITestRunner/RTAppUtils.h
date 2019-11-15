//
// RTAppUtils.h
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/13.
// Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTAppUtils : NSObject

+ (NSArray<NSString *> *)allAppBundleIds;

/// 获取设备信息
+ (NSDictionary *)getDeviceInfo;

/// 生成唯一的id
+ (NSString *)genIdentifier;

@end

NS_ASSUME_NONNULL_END
