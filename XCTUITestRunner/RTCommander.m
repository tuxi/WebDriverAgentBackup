//
// RTCommander.m
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/15.
// Copyright © 2019 Facebook. All rights reserved.
//

#import "RTCommander.h"
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
#import "XCUIElement+FBClassChain.h"
#import "FBPredicate.h"
#import "FBPasteboard.h"
#import "RTElementSelector.h"

static NSString *screenshotDirectory() {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths.firstObject;
  return [documentsDirectory stringByAppendingPathComponent:@"screenshot"];
}

@implementation RTCommander

@dynamic commander;

+ (RTCommander *)commander {
  static id _instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [RTCommander new];
  });
  return _instance;
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

- (BOOL)swipeFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint duration:(NSTimeInterval)duration error:(NSError * _Nullable *)error {
  XCUICoordinate *endCoordinate = [self.class gestureCoordinateWithCoordinate:endPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
  XCUICoordinate *startCoordinate = [self.class gestureCoordinateWithCoordinate:startPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
  [startCoordinate pressForDuration:duration thenDragToCoordinate:endCoordinate];
  return YES;
}



- (BOOL)screenshotWithDirectory:(NSString *)directory fileName:(NSString *)fileName error:(NSError * _Nullable *)error
{
  if (fileName.length == 0) {
    if (error) {
      *error = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"info": @"文件名称不能为空"}];
    }
    return NO;
  }
  
  if (![fileName.pathExtension.lowercaseString isEqualToString:@"png"] &&
      ![fileName.pathExtension.lowercaseString isEqualToString:@"jpg"]) {
    fileName = [fileName stringByAppendingString:@".png"];
  }
  
  if (directory.length == 0) {
    directory = screenshotDirectory();
    NSFileManager *fm= [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if(![fm fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory){
      [fm createDirectoryAtPath:screenshotDirectory() withIntermediateDirectories:YES attributes:nil error:nil];
    }
  }
  
  NSError *screenShotError;
  NSData *screenshotData = [self screenshotDataWithScale:1 error:&screenShotError];
  if (screenShotError) {
    if (error) {
      *error = screenShotError;
    }
    return NO;
  }
  BOOL flag = [screenshotData writeToFile:[directory stringByAppendingPathComponent:fileName] atomically:YES];
  if (flag) {
    NSLog(@"文件写入成功");
  }
//  NSString *screenshot = [screenshotData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
  return YES;
}

- (NSData *)screenshotDataWithScale:(CGFloat)scale error:(NSError * _Nullable __autoreleasing *)error
{
  UIImage *screenshotImage = [self screenshotImageWithScale:scale error:error];
  return UIImagePNGRepresentation(screenshotImage);
}

- (UIImage *)screenshotImageWithScale:(CGFloat)scale error:(NSError * _Nullable __autoreleasing *)error
{
  NSData *screenshotData = [[XCUIDevice sharedDevice] fb_screenshotWithError:error];
  // 通过XCUElement 截图会导致截图颠倒
//  XCUIElement *element = [FBSession activeSession].activeApplication;
//  NSData *screenshotData = [element fb_screenshotWithError:&screenShotError];
  if (*error) {
    return nil;
  }
  UIImage *screenshotImage = [UIImage imageWithData:screenshotData];
  // 需要修改图片的size为屏幕的size, 不然是按照2倍和3倍的size, 导致识图失败
  screenshotImage = [self.class scaleToSize:screenshotImage size:[self getWindowSize] scale:scale];
  return screenshotImage;
}

/**
 *  改变图片的大小
 *
 *  @param img     需要改变的图片
 *  @param newsize 新图片的大小
 *  @param scale 代表缩放, 0代表不缩放
 *
 *  @return 返回修改后的新图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize scale:(CGFloat)scale {
  // 创建一个bitmap的context
  // 并把它设置成为当前正在使用的context
  UIGraphicsBeginImageContextWithOptions(newsize, NO, scale);
  // 绘制改变大小的图片
  [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
  // 从当前context中创建一个改变大小后的图片
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  // 使当前的context出堆栈
  UIGraphicsEndImageContext();
  // 返回新的改变大小后的图片
  return scaledImage;
}

- (BOOL)tapWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable *)error {
  XCUIElement *element = [FBSession activeSession].activeApplication;
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
    if (nil == element) {
      XCUICoordinate *tapCoordinate = [self.class gestureCoordinateWithCoordinate:tapPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
      [tapCoordinate tap];
      return YES;
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
  else {
    
    // iOS 10 以上方法点击无效
    XCUICoordinate *tapCoordinate = [self.class gestureCoordinateWithCoordinate:tapPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
    [tapCoordinate tap];
    
    // 以下方法 在键盘弹出时, 点击的坐标混乱
    //  XCUIElement *element = [FBSession activeSession].activeApplication;
    //  if (!element) {
    //    element = [XCUIApplication new];
    //  }
    //  XCUICoordinate *normalized = [element coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
    //  [[normalized coordinateWithOffset:CGVectorMake(tapPoint.x, tapPoint.y)] tap];
    
    return YES;
  }
}

// iOS 10
- (BOOL)_tapWithPoint:(CGPoint)tapPoint error:(NSError * _Nullable *)error {

  XCUICoordinate *tapCoordinate = [self.class gestureCoordinateWithCoordinate:tapPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
  [tapCoordinate tap];
  return YES;
}


- (BOOL)tapHoldWithPoint:(CGPoint)tapPoint duration:(NSTimeInterval)duration error:(NSError * _Nullable *)error {
   XCUICoordinate *pressCoordinate = [self.class gestureCoordinateWithCoordinate:tapPoint application:[FBSession activeSession].activeApplication shouldApplyOrientationWorkaround:isSDKVersionLessThan(@"11.0")];
   [pressCoordinate pressForDuration:duration];
  return YES;
}

- (BOOL)tapWithClassName:(NSString *)className name:(NSString *)name label:(NSString *)label error:(NSError * _Nullable __autoreleasing *)error {
  NSArray<XCUIElement *> *elements = [self findElementsWithClassName:className name:name label:label];
  if (elements.count == 0) {
    return NO;
  }
  [elements.firstObject tap];
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
  if (className.length == 0 && name.length == 0 && label.length == 0) {
    return nil;
  }
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
- (BOOL)setElementText:(NSString *)text forClassName:(NSString *)className name:(NSString *_Nullable)name error:(NSError * _Nullable __autoreleasing *)error {
  return [self setElementText:text forClassName:className name:name error:error];
}
  
/// 给控件添加文本
- (BOOL)setElementText:(NSString *)text forClassName:(NSString *)className name:(NSString *_Nullable)name tryCount:(NSInteger)tryCount error:(NSError * _Nullable __autoreleasing *)error
{
  
  BOOL (^ setElementTextBlock)(NSString *, NSString *, NSString *, NSError **) = ^(NSString *_text, NSString *_Nullable _className, NSString *_Nullable _name, NSError * _Nullable __autoreleasing *_error) {
    XCUIElement *element = [self findElementsWithClassName:_className name:_name label:nil].firstObject;
    id value = _text;
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
  };
  
  tryCount = MAX(tryCount, 1);
  BOOL isSuccess = NO;
  while (tryCount > 0) {
    isSuccess = setElementTextBlock(text, className, name, error);
    sleep(2.0);
    tryCount--;
    if (isSuccess) {
      tryCount = 0;
    }
  }
  return isSuccess;
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
  
- (BOOL)setKeyboardTypeText:(NSString *)text error:(NSError *__autoreleasing  _Nullable *)error {
  NSUInteger frequency = [FBConfiguration maxTypingFrequency];
  return [FBKeyboard typeText:text frequency:frequency error:error];
}
  
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


@end
