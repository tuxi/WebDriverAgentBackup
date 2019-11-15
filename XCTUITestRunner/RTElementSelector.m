//
// RTElementSelector.m
// WebDriverAgent
//
// Created by xiaoyuan on 2019/11/13.
// Copyright © 2019 Facebook. All rights reserved.
//

#import "RTElementSelector.h"

NSArray *kELEMENTTypes() {
  NSArray *elements = nil;
  if (!elements) {
   elements = @[
        @"Any",
        @"Other",
        @"Application",
        @"Group",
        @"Window",
        @"Sheet",
        @"Drawer",
        @"Alert",
        @"Dialog",
        @"Button",
        @"RadioButton",
        @"RadioGroup",
        @"CheckBox",
        @"DisclosureTriangle",
        @"PopUpButton",
        @"ComboBox",
        @"MenuButton",
        @"ToolbarButton",
        @"Popover",
        @"Keyboard",
        @"Key",
        @"NavigationBar",
        @"TabBar",
        @"TabGroup",
        @"Toolbar",
        @"StatusBar",
        @"Table",
        @"TableRow",
        @"TableColumn",
        @"Outline",
        @"OutlineRow",
        @"Browser",
        @"CollectionView",
        @"Slider",
        @"PageIndicator",
        @"ProgressIndicator",
        @"ActivityIndicator",
        @"SegmentedControl",
        @"Picker",
        @"PickerWheel",
        @"Switch",
        @"Toggle",
        @"Link",
        @"Image",
        @"Icon",
        @"SearchField",
        @"ScrollView",
        @"ScrollBar",
        @"StaticText",
        @"TextField",
        @"SecureTextField",
        @"DatePicker",
        @"TextView",
        @"Menu",
        @"MenuItem",
        @"MenuBar",
        @"MenuBarItem",
        @"Map",
        @"WebView",
        @"IncrementArrow",
        @"DecrementArrow",
        @"Timeline",
        @"RatingIndicator",
        @"ValueIndicator",
        @"SplitGroup",
        @"Splitter",
        @"RelevanceIndicator",
        @"ColorWell",
        @"HelpTag",
        @"Matte",
        @"DockItem",
        @"Ruler",
        @"RulerMarker",
        @"Grid",
        @"LevelIndicator",
        @"Cell",
        @"LayoutArea",
        @"LayoutItem",
        @"Handle",
        @"Stepper",
        @"Tab",
    ];
  }
  return elements;
}

// 接元素的部分显示文字
RTElementUsingType RTElementUsingTypePartialLinkText = @"partial link text";
// 链接元素的全部显示文字
RTElementUsingType RTElementUsingTypeLinkText = @"link text";
// 元素的 name 属性，目前官方在移动端去掉这个定位方式，使用 AccessibilityId 替代
// 在 iOS 上，主要使用元素的label或name（两个属性的值都一样）属性进行定位，如该属性为空，如该属性为空，也是不能使用该属性。
RTElementUsingType RTElementUsingTypeName = @"name";
// 元素的 id 属性
RTElementUsingType RTElementUsingTypeId = @"id";
// Appium 中用于替代 name 定位方式
RTElementUsingType RTElementUsingTypeAccessibilityId = @"accessibility id";
// 元素的 class 属性, 比如查找某个UIButtion使用XCUIElementTypeButton即可
RTElementUsingType RTElementUsingTypeClassName = @"class name";
// 国外大神 Mykola Mokhnach 开发类似 xpath 的定位方式，仅支持  XCTest 框架，，不如 xpath 和 iOSNsPredicateString 好
// XCUIElementTypeWindow/XCUIElementTypeButton[3]
/*
 https://github.com/appium/appium-xcuitest-driver/pull/391
 element
 XCUIElementTypeWindow - select all the children windows
 XCUIElementTypeWindow[2] - select the second child window in the hierarchy. Indexing starts at 1
 XCUIElementTypeWindow/XCUIElementTypeAny[3] - select the third child (of any type) of the first child window
 XCUIElementTypeWindow[2]/XCUIElementTypeAny - select all the children of the second child window
 XCUIElementTypeWindow[2]/XCUIElementTypeAny[-2] - select the second last child of the second child
 */
RTElementUsingType RTElementUsingTypeClassChain = @"class chain";
// 比 css 定位方式稍弱一些的定位方法，但胜在容易上手，比较好使用，缺点就是速度慢一些。
// 由于 iOS 10开始使用的 XCUITest 框架原声不支持，定位速度很慢，所以官方现在不推荐大家使用，也有其他替代的定位方式可使用。
RTElementUsingType RTElementUsingTypeXpath = @"xpath";
// 谓词 仅支持 iOS 10或以上，可支持元素的单个属性和多个属性定位，推荐使用
RTElementUsingType RTElementUsingTypePredicateString = @"predicate string";

@implementation RTFindElementParamter

- (instancetype)initWithUsing:(RTElementUsingType)usingType value:(NSString *)value {
  self = [super init];
  if (self) {
    _usingType = usingType;
    _value = value;
  }
  return self;
}

@end

@implementation RTElementSelector

+ (instancetype)selectorWithClassName:(NSString *)className nameMatches:(NSString *)nameMatches {
  RTElementSelector *selector = [RTElementSelector new];
  
  return selector;
}

- (instancetype)initWithClassName:(NSString *)className nameMatches:(NSString *)nameMatches {
  self = [super init];
  if (self) {
    _index = 0;
    _className = className;
    _nameMatches = nameMatches;
    if (self.className.length > 0 && ![self.className hasPrefix:@"XCUIElementType"]) {
      self.className = [NSString stringWithFormat:@"XCUIElementType%@", self.className];
    }
    if (self.nameMatches.length) {
      if (![self.nameMatches hasPrefix:@"^"] && ![self.nameMatches hasPrefix:@".*"]) {
        self.nameMatches = [NSString stringWithFormat:@".*%@", self.nameMatches];
      }
      if (![self.nameMatches hasSuffix:@"$"] && ![self.nameMatches hasSuffix:@".*"]) {
        self.nameMatches = [NSString stringWithFormat:@"%@.*", self.nameMatches];
      }
    }
  }
  return self;
}
- (instancetype)init
{
  self = [super init];
  if (self) {
    _index = 0;
  }
  return self;
}

- (void)setClassName:(NSString *)className {
  _className = className;
  if (className.length > 0 && ![self.className hasPrefix:@"XCUIElementType"]) {
    _className = [NSString stringWithFormat:@"XCUIElementType%@", _className];
  }
}

- (void)setNameMatches:(NSString *)nameMatches {
  _nameMatches = nameMatches;
  if (nameMatches.length) {
    if (![nameMatches hasPrefix:@"^"] && ![nameMatches hasPrefix:@".*"]) {
      _nameMatches = [NSString stringWithFormat:@".*%@", nameMatches];
    }
    if (![nameMatches hasSuffix:@"$"] && ![nameMatches hasSuffix:@".*"]) {
      _nameMatches = [NSString stringWithFormat:@"%@.*", nameMatches];
    }
  }
}

- (NSString *)_gen_class_chain {
  // "**/XCUIElementTypeAny[`name == ' 搜索商品名称/淘宝宝贝标题'`]"
  if (self.predicate) {
    return [NSString stringWithFormat:@"/XCUIElementTypeAny[`%@`]", self.predicate];
  }
  NSMutableArray *qs = @[].mutableCopy;
  if (self.name.length) {
    [qs addObject:[NSString stringWithFormat:@"name == '%@'", self.name]];
  }
  if (self.nameContains.length) {
    [qs addObject:[NSString stringWithFormat:@"name CONTAINS '%@'", self.nameContains]];
  }
  if (self.nameMatches.length) {
    [qs addObject:[NSString stringWithFormat:@"name MATCHES '%@'", self.nameMatches]];
  }
  if (self.label.length) {
    [qs addObject:[NSString stringWithFormat:@"label == '%@'", self.label]];
  }
  if (self.labelContains.length) {
    [qs addObject:[NSString stringWithFormat:@"label CONTAINS '%@'", self.labelContains]];
  }
  if (self.value.length) {
    [qs addObject:[NSString stringWithFormat:@"value == '%@'", self.value]];
  }
  if (self.valueContains.length) {
    [qs addObject:[NSString stringWithFormat:@"value CONTAINS '%@'", self.valueContains]];
  }
  if (self.visible) {
    [qs addObject:[NSString stringWithFormat:@"visible == %@", self.visible ? @"'true'" : @"'false'"]];
  }
  if (self.enabled) {
    [qs addObject:[NSString stringWithFormat:@"enabled == %@", self.enabled ? @"'true'" : @"'false'"]];
  }
  
  NSString *predicate = [qs componentsJoinedByString:@" AND "]?:@"";
  NSString *chain = [NSString stringWithFormat:@"/%@", self.className ?: @"XCUIElementTypeAny"];
  if (predicate.length > 0) {
    chain = [NSString stringWithFormat:@"%@[`%@`]", chain, predicate];
  }
  if (self.index) {
    chain = [NSString stringWithFormat:@"%@[%ld]", chain, self.index];
  }
  return chain;
}

- (RTFindElementParamter *)genFindElementParmter {
  if (self.uuid.length > 0) {
    return [[RTFindElementParamter alloc] initWithUsing:RTElementUsingTypeId value:(NSString *)self.uuid];
  }
  if (self.predicate.length > 0) {
    return [[RTFindElementParamter alloc] initWithUsing:RTElementUsingTypePredicateString value:(NSString *)self.predicate];
  }
  if (self.xpath.length > 0) {
    return [[RTFindElementParamter alloc] initWithUsing:RTElementUsingTypeXpath value:(NSString *)self.xpath];
  }
  if (self.classChain.length > 0) {
    return [[RTFindElementParamter alloc] initWithUsing:RTElementUsingTypeClassChain value:(NSString *)self.classChain];

  }
  NSString *chain = [self.parent_class_chains componentsJoinedByString:@""]?:@"";
  chain = [NSString stringWithFormat:@"**%@%@", chain, [self _gen_class_chain]];
  
  return [[RTFindElementParamter alloc] initWithUsing:RTElementUsingTypeClassChain value:chain];
}

//- (NSString *_Nullable)_fix_xcui_type:(NSString *)classChain {
//  if (!classChain) {
//    return nil;
//  }
//  // 使用|拼接数组所有元素为字符串
//  NSString *reElement = [kELEMENTTypes() componentsJoinedByString:@"|"];
//  reElement = [NSString stringWithFormat:@"/(%@)", reElement];
//  // python字符串替换之re.sub()
////  return re.sub(r'/('+re_element+')", '/XCUIElementType\g<1>", s)
//  return reElement;
//}

//def _fix_xcui_type(self, s):
//    if s is None:
//        return
//    re_element = '|'.join(xcui_element_types.ELEMENTS)
//    return re.sub(r'/('+re_element+')", '/XCUIElementType\g<1>", s)
@end

