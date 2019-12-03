//
// RTCommanderProtocol.h
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/15.
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

@protocol RTCommanderProtocol <NSObject>

/// 滑动屏幕事件
/// @param direction 移动屏幕的方向
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)swipeWithDirection:(RTSwipedirection)direction error:(NSError * _Nullable __autoreleasing *)error;

/// 滑动屏幕事件, 从起始点滑动到终点
/// @param startPoint 起始点
/// @param endPoint 终点
/// @param duration 移动的时间
/// @param error 错误回调
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)swipeFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint duration:(NSTimeInterval)duration error:(NSError * _Nullable *)error;

/// 屏幕截图
/// @param error 返回失败错误的信息
/// @param directory 截图存储的目录, 可为空, 如果是空使用默认的文件名称为screenshot
/// @param fileName 截图的文件名称 文件名称可以是 [截图1.png] 或者 [截图1]
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)screenshotWithDirectory:(NSString *_Nullable)directory fileName:(NSString *)fileName error:(NSError * _Nullable __autoreleasing *)error;

/// 获取屏幕截图
/// @param scale 缩放比率 0 ~ 1
/// @param error 返回的错误
/// @return 返回值为图片的data
- (NSData * _Nullable)screenshotDataWithScale:(CGFloat)scale error:(NSError * _Nullable __autoreleasing *)error;

- (UIImage *_Nullable)screenshotImageWithScale:(CGFloat)scale error:(NSError * _Nullable __autoreleasing *)error;

/// 点击事件
/// @param tapPoint 要点击的坐标
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)tapWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable __autoreleasing *)error;

/// 点击事件
/// @param className 点击的元素的过滤条件 类型名称
/// @param name 点击的元素的过滤条件 元素的名称
/// @param label 点击的元素的过滤条件 比如button 的icon名称
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)tapWithClassName:(NSString *_Nullable)className name:(NSString *_Nullable)name label:(NSString *_Nullable)label error:(NSError * _Nullable __autoreleasing *)error;


/// 长按事件
/// @param tapPoint 要点击的坐标
/// @param duration 长按的时间
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)tapHoldWithPoint:(CGPoint)tapPoint duration:(NSTimeInterval)duration error:(NSError * _Nullable __autoreleasing *)error;

/// 点击事件 与 tapWithPoint::都可以实现点击
/// @param tapPoint 要点击的坐标
/// @param error 返回失败错误的信息
/// @return 返回值bool类型, YES 代表成功 NO 失败
- (BOOL)clickWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable __autoreleasing *)error;

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
/// @param tryCount 尝试的次数 填充文本可能会失败, 可多次重试, 最少1次
- (BOOL)setElementText:(NSString *)text forClassName:(NSString *)className name:(NSString *_Nullable)name tryCount:(NSInteger)tryCount error:(NSError * _Nullable __autoreleasing *)error;

- (BOOL)setElementText:(NSString *)text forClassName:(NSString *)className name:(NSString *_Nullable)name error:(NSError * _Nullable __autoreleasing *)error;

/// 直接设置键盘输入文本, 前提键盘必须弹出的
- (BOOL)setKeyboardTypeText:(NSString *)text error:(NSError **)error;

#if !TARGET_OS_TV
/// 给剪切板设置内容
/// @param contentType 设置内容的类型，可以是图片或者文字
/// @param content 要设置的内容， 如果是图片，请将图片转换为base64编码的字符串
- (BOOL)setPasteboard:(NSString *)content contentType:(RTPasteBoardContentType)contentType error:(NSError * _Nullable __autoreleasing *)error;
- (NSString * _Nullable)getPasteboardWithContentType:(RTPasteBoardContentType)contentType error:(NSError * _Nullable __autoreleasing *)error;

/// 根据UI元素的className获取UI元素
/// @param className 要查找的类名
/// @param name 控件的名称，比如控件的text
/// @param label 比如button 的icon名称 ， 比如完美世界游戏左侧悬浮窗的名称为common toolbar icon normal
- (NSArray * _Nullable)findElementsWithClassName:(NSString *_Nullable)className name:(NSString *_Nullable)name label:(NSString *_Nullable)label;

//- (NSArray<XCUIElement *> * _Nullable)findElementsWithClassName:(NSString *_Nullable)className name:(NSString *_Nullable)name label:(NSString *_Nullable)label;

#endif

- (CGSize)getWindowSize;

@end

NS_ASSUME_NONNULL_END
