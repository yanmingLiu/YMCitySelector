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


/// 选择回调
@property (nonatomic, copy) void (^callback) (NSString *province, NSString *city,NSString *area) ;

/// 设置默认数据、在show方法后面调用
/// @param province 省
/// @param city 市
/// @param area 区
- (void)fillDefaultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
