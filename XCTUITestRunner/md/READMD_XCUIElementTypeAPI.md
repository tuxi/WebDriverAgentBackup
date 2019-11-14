### XCUIElementType API

类型
Any
任意对象

Unknown
未知对象

Application
应用对象，一个应用只有一个Application对象。

Group
Window
一个Window代表一个界面，为界面的第一层View，其他所有的控件是在该Window中。

Sheet
Drawer
Alert
提示框

Dialog
对话框

Button
按钮

RadioButton
单选按钮

RadioGroup
单选按钮组

CheckBox
复选框

DisclosureTriangle
折叠三角形控件，一般用于隐藏一些详细内容，可以点击展开这些信息

PopUpButton
弹出式按钮

ComboBox
组合框

MenuButton
菜单按钮

ToolbarButton
工具栏按钮

Popover
弹出框

Keyboard
键盘

Key
NavigationBar
导航栏

TabBar
标签栏

TabGroup
标签组

Toolbar
工具栏

StatusBar
状态栏

Table
表格

TableRow
表格行

TableColumn
表格列

Outline
轮廓控件

OutlineRow
轮廓控件的行

Browser
浏览器

CollectionView
UICollectionView对象

Slider
滑块控件

PageIndicator
页面指示器

ProgressIndicator
进度指示器

ActivityIndicator
进度指示器的一种，有一个圆圈在转动，主要用在一些耗时的操作上。

SegmentedControl
分割控件

Picker
滑动式选择控件

PickerWheel
滚轮式选择控件

Switch
开关

Toggle
开关

Link
Image
图片控件

Icon
SearchField
搜索框

ScrollView
滚动视图

ScrollBar
滚动条

StaticText
静态文本

TextField
编辑框，可编辑

DateField
编辑框的一种，只能输入日期

TimeField
编辑框的一种，只能输入时间

TextView
文本框

Menu
菜单

MenuItem
菜单元素

MenuBar
菜单栏

MenuBarItem
菜单栏元素

Map
地图

WebView
网页视图控件

IncrementArrow
增长箭头

DecrementArrow
负增长箭头

Timeline
时间线

RatingIndicator
百分比指示器

ValueIndicator
值指示器

SplitGroup
分割组

Splitter
分割器

RelevanceIndicator
ColorWell
HelpTag
帮助标签

Matte
DockItem
类似OS X中docker菜单里的元素

Ruler
标尺

RulerMarker
代表一个NSRulerView对象

Grid
网格

LevelIndicator
层级指示器

Cell
table中的一个单元叫一个cell

LayoutArea
布局区域

LayoutItem
布局元素

Handle
源码
Swift
```
@available(iOS 9.0, *)
enum XCUIElementType : UInt {

    case Any
    case Unknown
    case Application
    case Group
    case Window
    case Sheet
    case Drawer
    case Alert
    case Dialog
    case Button
    case RadioButton
    case RadioGroup
    case CheckBox
    case DisclosureTriangle
    case PopUpButton
    case ComboBox
    case MenuButton
    case ToolbarButton
    case Popover
    case Keyboard
    case Key
    case NavigationBar
    case TabBar
    case TabGroup
    case Toolbar
    case StatusBar
    case Table
    case TableRow
    case TableColumn
    case Outline
    case OutlineRow
    case Browser
    case CollectionView
    case Slider
    case PageIndicator
    case ProgressIndicator
    case ActivityIndicator
    case SegmentedControl
    case Picker
    case PickerWheel
    case Switch
    case Toggle
    case Link
    case Image
    case Icon
    case SearchField
    case ScrollView
    case ScrollBar
    case StaticText
    case TextField
    case DateField
    case TimeField
    case TextView
    case Menu
    case MenuItem
    case MenuBar
    case MenuBarItem
    case Map
    case WebView
    case IncrementArrow
    case DecrementArrow
    case Timeline
    case RatingIndicator
    case ValueIndicator
    case SplitGroup
    case Splitter
    case RelevanceIndicator
    case ColorWell
    case HelpTag
    case Matte
    case DockItem
    case Ruler
    case RulerMarker
    case Grid
    case LevelIndicator
    case Cell
    case LayoutArea
    case LayoutItem
    case Handle
}
```

OC
```
NS_ENUM_AVAILABLE(10_11, 9_0)
typedef NS_ENUM(NSUInteger, XCUIElementType) {
    XCUIElementTypeAny,
    XCUIElementTypeUnknown,
    XCUIElementTypeApplication,
    XCUIElementTypeGroup,
    XCUIElementTypeWindow,
    XCUIElementTypeSheet,
    XCUIElementTypeDrawer,
    XCUIElementTypeAlert,
    XCUIElementTypeDialog,
    XCUIElementTypeButton,
    XCUIElementTypeRadioButton,
    XCUIElementTypeRadioGroup,
    XCUIElementTypeCheckBox,
    XCUIElementTypeDisclosureTriangle,
    XCUIElementTypePopUpButton,
    XCUIElementTypeComboBox,
    XCUIElementTypeMenuButton,
    XCUIElementTypeToolbarButton,
    XCUIElementTypePopover,
    XCUIElementTypeKeyboard,
    XCUIElementTypeKey,
    XCUIElementTypeNavigationBar,
    XCUIElementTypeTabBar,
    XCUIElementTypeTabGroup,
    XCUIElementTypeToolbar,
    XCUIElementTypeStatusBar,
    XCUIElementTypeTable,
    XCUIElementTypeTableRow,
    XCUIElementTypeTableColumn,
    XCUIElementTypeOutline,
    XCUIElementTypeOutlineRow,
    XCUIElementTypeBrowser,
    XCUIElementTypeCollectionView,
    XCUIElementTypeSlider,
    XCUIElementTypePageIndicator,
    XCUIElementTypeProgressIndicator,
    XCUIElementTypeActivityIndicator,
    XCUIElementTypeSegmentedControl,
    XCUIElementTypePicker,
    XCUIElementTypePickerWheel,
    XCUIElementTypeSwitch,
    XCUIElementTypeToggle,
    XCUIElementTypeLink,
    XCUIElementTypeImage,
    XCUIElementTypeIcon,
    XCUIElementTypeSearchField,
    XCUIElementTypeScrollView,
    XCUIElementTypeScrollBar,
    XCUIElementTypeStaticText,
    XCUIElementTypeTextField,
    XCUIElementTypeDateField,
    XCUIElementTypeTimeField,
    XCUIElementTypeTextView,
    XCUIElementTypeMenu,
    XCUIElementTypeMenuItem,
    XCUIElementTypeMenuBar,
    XCUIElementTypeMenuBarItem,
    XCUIElementTypeMap,
    XCUIElementTypeWebView,
    XCUIElementTypeIncrementArrow,
    XCUIElementTypeDecrementArrow,
    XCUIElementTypeTimeline,
    XCUIElementTypeRatingIndicator,
    XCUIElementTypeValueIndicator,
    XCUIElementTypeSplitGroup,
    XCUIElementTypeSplitter,
    XCUIElementTypeRelevanceIndicator,
    XCUIElementTypeColorWell,
    XCUIElementTypeHelpTag,
    XCUIElementTypeMatte,
    XCUIElementTypeDockItem,
    XCUIElementTypeRuler,
    XCUIElementTypeRulerMarker,
    XCUIElementTypeGrid,
    XCUIElementTypeLevelIndicator,
    XCUIElementTypeCell,
    XCUIElementTypeLayoutArea,
    XCUIElementTypeLayoutItem,
    XCUIElementTypeHandle,
};
```
