//
//  UIView+HJThemeView.h
//  HJPaaS
//
//  Created by admin on 2020/12/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HJThemeView)
/// 设置皮肤文件名称 默认为空值，取当前皮肤  eg:  @"Dark" / @"Light" ； hj_defaultThemeKey 为默认皮肤
@property (nonatomic, strong) NSString *hj_themeStyle;
@property (nonatomic, strong) NSString *hj_themeBackgroundColor;
@property (nonatomic, strong) NSString *hj_themeTintColor;
/// 根据路径获取color 并缓存方法和参数 ()
- (void)hj_setThemeColorWithIvarName:(NSString *)ivarName colorPath:(NSString *)path;
@end

@interface UILabel (HJThemeLabel)
@property (nonatomic, strong) NSString *hj_themeTextColor;
@property (nonatomic, strong) NSString *hj_themeHighlightedTextColor;
@property (nonatomic, strong) NSString *hj_themeShadowColor;
/// 主要是颜色
@property (nonatomic, strong) NSAttributedString *hj_themeAttributedText;

@end

@interface UITextField (HJThemeTextField)
@property (nonatomic, strong) NSString *hj_themeTextColor;
@end

@interface UITextView (HJThemeTextView)
@property (nonatomic, strong) NSString *hj_themeTextColor;
@end

@interface UIImageView (HJThemeImageView)
@property (nonatomic, strong) NSString *hj_themeImage;
@end

@interface UIButton (HJThemeButton)

- (void)hj_themeSetImage:(NSString *)path forState:(UIControlState)state;
- (void)hj_themeSetBackgroundImage:(NSString *)path forState:(UIControlState)state;
- (void)hj_themeSetTitleColor:(NSString *)path forState:(UIControlState)state;

@end

@interface UISwitch (HJThemeSwitch)
@property (nonatomic, strong) NSString *hj_themeOnTintColor;
@property (nonatomic, strong) NSString *hj_themeThumbTintColor;
@end

@interface UISegmentedControl (HJThemeSegmented)
@property (nonatomic, strong) NSString *hj_themeSelectedSegmentTintColor;
- (void)hj_themeSetTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state;
@end

@interface UISlider (HJThemeSlider)
@property (nonatomic, strong) NSString *hj_themeThumbTintColor;
@property (nonatomic, strong) NSString *hj_themeMinimumTrackTintColor;
@property (nonatomic, strong) NSString *hj_themeMaximumTrackTintColor;

@end



@interface CALayer (HJThemeLayer)
/// 设置皮肤文件名称 默认为空值，取当前皮肤  eg:  @"Dark" / @"Light" ； hj_defaultThemeKey 为默认皮肤
@property (nonatomic, strong) NSString *hj_themeStyle;
@property (nonatomic, strong) NSString *hj_themeBackgroundColor;
@property (nonatomic, strong) NSString *hj_themeBorderColor;
@property (nonatomic, strong) NSString *hj_themeShadowColor;
/// 根据路径获取cgcolor 并缓存方法和参数 ()
- (void)hj_setThemeCGColorWithIvarName:(NSString *)ivarName colorPath:(NSString *)path;
@end

@interface CAGradientLayer (HJThemeGradientLayer)
/// eg: 色值数组路径;
@property (nonatomic, strong) NSString *hj_themeColors;

@end

@interface UIBarAppearance (HJThemeBarAppearance)
@property (nonatomic, strong) NSString *hj_themeBackgroundColor;
@property (nonatomic, strong) NSString *hj_themeBackgroundImage;
@property (nonatomic, strong) NSString *hj_themeShadowColor;
@property (nonatomic, strong) NSString *hj_themeShadowImage;
@end

@interface UITableView (HJThemeTableView)
@property (nonatomic, strong) NSString *hj_themeSeparatorColor;
@property (nonatomic, strong) NSString *hj_themeSectionIndexColor;
@property (nonatomic, strong) NSString *hj_themeSectionIndexBackgroundColor;

@end

@interface UITabBarItem (HJThemeTabBarItem)
@property (nonatomic, strong) NSString *hj_themeSelectedImage;

@end



@interface UINavigationBar (HJThemeNavigationBar)
@property (nonatomic, strong) NSString *hj_themeBarTintColor;

@end

NS_ASSUME_NONNULL_END
