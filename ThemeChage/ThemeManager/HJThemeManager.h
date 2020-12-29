//
//  HJThemeManager.h
//  HJPaaS
//
//  Created by admin on 2020/12/17.
//

#import <Foundation/Foundation.h>
#import "UIColor+HJFactory.h"
#import "HJColorKey.h"
#import "HJImageKey.h"
#import "UIView+HJThemeView.h"

NS_ASSUME_NONNULL_BEGIN

/// 改变肤色会用该通知
#define HJ_ThemeUpdateNotification @"HJ_ThemeUpdateNotification"
/// 默认皮肤样式
#define hj_defaultLightThemeKey @"hj_defaultLightTheme"

/// 皮肤协议
@protocol HJThemeProtocol <NSObject>

- (NSDictionary *)getThemeDicWithName:(NSString *)name;
- (NSDictionary *)getDefaultThemeDic;
- (NSString *)getDarkThemeName;
- (void)getImageForUrl:(NSString *_Nullable)url completeBlock:(void(^_Nullable)(UIImage *_Nullable image))completeBlock;
@end

@interface HJThemeManager : NSObject
/// 默认皮肤（如果其他皮肤没有设置，则读取默认皮肤设置）
@property (nonatomic, strong) id<HJThemeProtocol> themeProtocol;
@property (nonatomic, strong) NSDictionary  * hj_defaultThemeDic;
@property (nonatomic, strong) NSDictionary  * hj_currentThemeDic;
@property (nonatomic, strong) NSMutableDictionary  * hj_themeDic;
@property (nonatomic, strong) NSString      * hj_currentThemeStyle;

+ (instancetype)sharedInstance;
/// 更换主题，设置主题名称，
- (void)switchThemeWithName:(NSString *)themeName;
- (NSString *)getCurrentTheme;
- (void)restoreLastTheme;
- (void)saveLastTheme;
/// 根据路径获取图片
- (void)hj_getImageWithKeyPath:(NSString *)keyPath
                     themeStyle:(NSString *)themeStyle
                  imageCallBack:(void(^)(UIImage *image))callBack;
/// 根据路径获取颜色
- (void)hj_getColorWithKeyPath:(NSString *)keyPath
                     themeStyle:(NSString *)themeStyle
                  colorCallBack:(void(^)(UIColor *color))callBack;

/// 根据路径获取颜色数组
- (void)hj_getColorsWithKeyPath:(NSString *)keyPath
                      themeStyle:(NSString *)themeStyle
                   colorCallBack:(void(^)(NSArray<UIColor *> *colors))callBack;

//- (HJThemeManager * _Nonnull(^)(NSString * _Nonnull className))addWhiteName;


//- (void)HJ_refreshAllUIThemeMethod;
//- (BOOL)HJ_isDefaultThemeController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
