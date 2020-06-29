//
//  YMCitySelector.h
//  Pods-YMCitySelector_Example
//
//  Created by mni on 2020/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*--------------------=======分类，利用yymodel解析数组========----------------------*/

@interface NSObject (YM)

+ (NSArray *)ym_modelArrayWithJsons:(id)jsons;
/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可s
 */
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;

@end

/*--------------------=======数据模型========----------------------*/

@interface AXCity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<NSString *> *area;

@end

@interface AXProvince : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<AXCity *> *city;

/// 获取所有城市数据
+ (NSArray<AXProvince *> * _Nullable )getRegions;

@end

/*--------------------=======城市选择器========----------------------*/

@interface YMCitySelector : UIViewController

/// tableView 背景色
@property (nonatomic, strong) UIColor *fistTableViewColor;
@property (nonatomic, strong) UIColor *secondTableViewColor;
@property (nonatomic, strong) UIColor *thirdTableViewColor;
/// 文字字体 默认15
@property (nonatomic, strong) UIFont *textFont;
/// 默认文字颜色 默认 #484848
@property (nonatomic, strong) UIColor *textDefaultColor;
/// 选中时文字颜色 默认 #22BB62
@property (nonatomic, strong) UIColor *textSelectedtColor;
/// 取消按钮
@property (nonatomic, strong) UIColor *cancelBtnColor;
/// 确定按钮
@property (nonatomic, strong) UIColor *sureBtnColor;
/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 标题文字
@property (nonatomic, strong) NSString *topTitle;
/// 标题字体
@property (nonatomic, strong) UIFont *titleFont;


/// 选择回调
@property (nonatomic, copy) void (^callback) (NSString *province, NSString *city,NSString *area) ;

/// 设置默认数据、在show方法后面调用
/// @param province 省
/// @param city 市
/// @param area 区
- (void)fillDefaultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area;

/// 显示
- (void)show;

/// 关闭
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
