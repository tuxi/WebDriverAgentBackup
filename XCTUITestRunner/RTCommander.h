//
// RTCommander.h
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/15.
// Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCommanderProtocol.h"

NS_ASSUME_NONNULL_BEGIN



@interface RTCommander : NSObject <RTCommanderProtocol>

@property (nonatomic, class, readonly, strong) RTCommander *commander;
 

@end
NS_ASSUME_NONNULL_END
