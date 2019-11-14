//
// AutomationScript.h
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/12.
// Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RTSwipedirection) {
  RTSwipedirectionUnknow,
  RTSwipedirectionUp,
  RTSwipedirectionDown,
  RTSwipedirectionLeft,
  RTSwipedirectionRight,
};

typedef NS_ENUM(NSInteger, RTPasteBoardContentType) {
  RTPasteBoardContentTypeUnknow,
  RTPasteBoardContentTypePlaintext,
  RTPasteBoardContentTypeImage,
  RTPasteBoardContentTypeURL,
};

@interface AutomationScript : NSObject

- (void)start;

/// 滑动屏幕事件
/// @param direction 移动屏幕的方向
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)swipeWithDirection:(RTSwipedirection)direction error:(NSError * _Nullable __autoreleasing *)error;

/// 屏幕截图
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)screenshotWithError:(NSError * _Nullable __autoreleasing *)error;

/// 点击事件
/// @param tapPoint 要点击的坐标
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)tapWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable __autoreleasing *)error;

/// 点击事件 与 tapWithPoint::都可以实现点击
/// @param tapPoint 要点击的坐标
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)clickWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable *)error;

/// 双击
- (void)doubleTapWithPoint:(CGPoint)point;

/// 根据包名启动APP
- (void)launchAppWithBundleId:(NSString *)bundleIdentifier;
/// 杀死app
- (void)terminateAppWithBundleId:(NSString *)bundleIdentifier;
/// 停用app一段时间
- (BOOL)deactivateppWithBundleId:(NSString *)bundleIdentifier duration:(NSTimeInterval)duration error:(NSError * _Nullable __autoreleasing *)error;

- (BOOL)lockWithError:(NSError * _Nullable __autoreleasing *)error;
- (BOOL)unlockWithError:(NSError * _Nullable __autoreleasing *)error;

/// 回到主屏幕
- (BOOL)goHomeScreenWithError:(NSError * _Nullable __autoreleasing *)error;

/// 隐藏键盘
- (BOOL)hideKeyboardWithError:(NSError * _Nullable __autoreleasing *)error;

/// 获取当前活跃app的信息
- (NSDictionary *)getActiveApp;

/// 获取当前全部弹框buttons
- (NSArray<NSString *> * _Nullable)getAlertButtons;
- (NSString *_Nullable)getAlertText;

/// 关掉带有ok 的弹框
- (BOOL)dismissOkAlertWithError:(NSError * _Nullable __autoreleasing *)error;

/// 通过className查找控件, 并给q它填充文本
/// @param text 需要填充的文本, 尾部加入\n会执行键盘下一步操作, 比如搜索框会执行搜索
/// @param className 要填充文本的控件类型 extern NSArray *kELEMENTTypes(void);
/// @param name 控件的名称, 可联合className
- (BOOL)setElementText:(NSString *)text forClassName:(NSString *)className name:(NSString *_Nullable)name  error:(NSError * _Nullable __autoreleasing *)error;

#if !TARGET_OS_TV
/// 给剪切板设置内容
/// @param contentType 设置内容的类型，可以是图片或者文字
/// @param content 要设置的内容， 如果是图片，请将图片转换为base64编码的字符串
- (BOOL)setPasteboard:(NSString *)content contentType:(RTPasteBoardContentType)contentType error:(NSError * _Nullable __autoreleasing *)error;
- (NSString * _Nullable)getPasteboardWithContentType:(RTPasteBoardContentType)contentType error:(NSError * _Nullable __autoreleasing *)error;;

#endif
@end

NS_ASSUME_NONNULL_END
