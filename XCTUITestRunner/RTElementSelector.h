//
// RTElementSelector.h
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/13.
// Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "using" can be on of:
 "partial link text", "link text"
 "name", "id", "accessibility id"
 "class name", "class chain", "xpath", "predicate string"
 */
typedef NSString * RTElementUsingType NS_STRING_ENUM;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypePartialLinkText;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeLinkText;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeName;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeId;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeAccessibilityId;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeClassName;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeClassChain;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypeXpath;
FOUNDATION_EXPORT RTElementUsingType RTElementUsingTypePredicateString;

extern NSArray *kELEMENTTypes(void);

//Args:
//    predicate (str): predicate string
//    id (str): raw identifier
//    className (str): attr of className
//    type (str): alias of className
//    name (str): attr for name
//    nameContains (str): attr of name contains
//    nameMatches (str): regex string
//    text (str): alias of name
//    textContains (str): alias of nameContains
//    textMatches (str): alias of nameMatches
//    value (str): attr of value, not used in most times
//    valueContains (str): attr of value contains
//    label (str): attr for label
//    labelContains (str): attr for label contains
//    visible (bool): is visible
//    enabled (bool): is enabled
//    classChain (str): string of ios chain query, eg: **/XCUIElementTypeOther[`value BEGINSWITH 'blabla'`]
//    xpath (str): xpath string, a little slow, but works fine
//    timeout (float): maxium wait element time, default 10.0s
//    index (int): index of founded elements
//
//WDA use two key to find elements "using", "value"
//Examples:
//"using" can be on of
//    "partial link text", "link text"
//    "name", "id", "accessibility id"
//    "class name", "class chain", "xpath", "predicate string"
//
//predicate string support many keys
//    UID,
//    accessibilityContainer,
//    accessible,
//    enabled,
//    frame,
//    label,
//    name,
//    rect,
//    type,
//    value,
//    visible,
//    wdAccessibilityContainer,
//    wdAccessible,
//    wdEnabled,
//    wdFrame,
//    wdLabel,
//    wdName,
//    wdRect,
//    wdType,
//    wdUID,
//    wdValue,
//    wdVisible


@interface RTFindElementParamter : NSObject

@property (nonatomic, copy) RTElementUsingType usingType;
@property (nonatomic, copy) NSString *value;

- (instancetype)initWithUsing:(RTElementUsingType)usingType value:(NSString *)value;

@end

@interface RTElementSelector : NSObject
@property (nonatomic, copy, nullable) NSString *predicate;
@property (nonatomic, copy, nullable) NSString *uuid;
@property (nonatomic, copy, nullable) NSString *className;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *nameContains;
@property (nonatomic, copy, nullable) NSString *nameMatches;

@property (nonatomic, copy, nullable) NSString *value;
@property (nonatomic, copy, nullable) NSString *valueContains;
@property (nonatomic, copy, nullable) NSString *label;
@property (nonatomic, copy, nullable) NSString *labelContains;
@property (nonatomic, strong, nullable) NSNumber *visible;
@property (nonatomic, strong, nullable) NSNumber *enabled;
@property (nonatomic, copy, nullable) NSString *classChain;
@property (nonatomic, copy, nullable) NSString *xpath;
@property (nonatomic, strong, nullable) NSArray<NSString *> *parent_class_chains;
@property (nonatomic, assign) NSInteger index;


+ (instancetype)selectorWithClassName:(NSString *)className nameMatches:(NSString *)nameMatches;

- (RTFindElementParamter *)genFindElementParmter;
    
@end

NS_ASSUME_NONNULL_END
