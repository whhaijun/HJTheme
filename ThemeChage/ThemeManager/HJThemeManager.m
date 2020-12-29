//
//  HJThemeManager.m
//  HJPaaS
//
//  Created by admin on 2020/12/17.
//

#import "HJThemeManager.h"


#define HJ_lastThemeIndexKey @"lastedThemeIndex"

@implementation HJThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static HJThemeManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    [instance getDefaultThemeDicMethod];
    return instance;
}

- (void)getDefaultThemeDicMethod {
    self.hj_defaultThemeDic = [self.themeProtocol getDefaultThemeDic];
    self.hj_themeDic[hj_defaultLightThemeKey] = self.hj_defaultThemeDic;
}

- (void)switchThemeWithName:(NSString *)themeName {
    if (themeName.length > 0) {
        if ([themeName isEqualToString:self.hj_currentThemeStyle]) {
            return;
        }
        if (!self.hj_themeDic[themeName]) {
            self.hj_currentThemeDic = [self.themeProtocol getThemeDicWithName:themeName];
            self.hj_themeDic[themeName] = self.hj_currentThemeDic;
        }
        else {
            
            self.hj_currentThemeDic = self.hj_themeDic[themeName];
        }
        self.hj_currentThemeStyle = themeName;        
    }
    else {
        self.hj_currentThemeDic = self.hj_defaultThemeDic;
        self.hj_themeDic[hj_defaultLightThemeKey] = self.hj_currentThemeDic;
        self.hj_currentThemeStyle = hj_defaultLightThemeKey;
    }
    [self HJ_refreshAllUIThemeMethod];
}

- (NSString *)getCurrentTheme {
    return self.hj_currentThemeStyle;
}

- (void)restoreLastTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [defaults stringForKey:HJ_lastThemeIndexKey];
    if (type.length > 0) {
        [self switchThemeWithName:type];
    }
}

- (void)saveLastTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.hj_currentThemeStyle forKey:HJ_lastThemeIndexKey];
}

//- (HJThemeManager * _Nonnull(^)(NSString  * _Nonnull className))addWhiteName {
//    return ^HJThemeManager *(NSString * name) {
//        if (name.length == 0 || name == nil) {
//            return [HJThemeManager sharedInstance];
//        }
//        [[HJThemeManager sharedInstance].HJ_defaultThemeVCArr addObject:name];
//        return [HJThemeManager sharedInstance];
//    };
//}

//- (NSMutableArray *)HJ_defaultThemeVCArr {
//    if (!_HJ_defaultThemeVCArr) {
//        _HJ_defaultThemeVCArr = @[].mutableCopy;
//    }
//    return _HJ_defaultThemeVCArr;
//}

/// 根据路径获取图片
- (void)hj_getImageWithKeyPath:(NSString *)keyPath themeStyle:(NSString *)themeStyle imageCallBack:(void(^)(UIImage *image))callBack{
    NSString *imageStr = [self hj_getContentStringWithKeyPath:keyPath themeStyle:themeStyle];
    if (imageStr == nil || imageStr.length == 0) {
        return;
    }
    __block UIImage *imageUI;
    [self.themeProtocol getImageForUrl:imageStr completeBlock:^(UIImage * _Nullable image) {
        if (callBack) {
            imageUI = image;
            callBack(image);
        }
    }];
}

/// 根据路径获取颜色
- (void)hj_getColorWithKeyPath:(NSString *)keyPath themeStyle:(NSString *)themeStyle colorCallBack:(void(^)(UIColor *color))callBack{
    NSString *colorStr = [self hj_getContentStringWithKeyPath:keyPath themeStyle:themeStyle];
    if (colorStr.length > 0) {
        if (callBack) {
            callBack([UIColor colorFromHexString:colorStr]);
        }
    }
}
/// 根据路径获取颜色数组
- (void)hj_getColorsWithKeyPath:(NSString *)keyPath themeStyle:(NSString *)themeStyle colorCallBack:(void(^)(NSArray<UIColor *> *colors))callBack {
    NSArray<NSString *> *colorsStr = [self hj_getContentStringWithKeyPath:keyPath themeStyle:themeStyle];
    NSMutableArray *colors = @[].mutableCopy;
    [colorsStr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            [colors addObject:[UIColor colorFromHexString:obj]];
        }
    }];
    if (callBack) {
        callBack(colors);
    }
}

- (void)HJ_refreshAllUIThemeMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:HJ_ThemeUpdateNotification object:nil];
}

/// 判断当前主题是否有该路径设置，如果没有读取默认主题
- (id)hj_getContentStringWithKeyPath:(NSString *)keyPath themeStyle:(NSString *)themeStyle{
    NSDictionary *dic;
    if (themeStyle.length > 0) {
        dic = self.hj_themeDic[themeStyle];
        if (dic == nil) {
            dic = [self.themeProtocol getThemeDicWithName:themeStyle];
            NSString *hintStr = [NSString stringWithFormat:@"设置的主题%@找不到，请检查",themeStyle];
            NSAssert(dic.count > 0, hintStr);
            self.hj_themeDic[themeStyle] = dic;
        }
    }
    else {
        dic = self.hj_currentThemeDic;
        if (dic == nil || dic.count == 0) {
            dic = self.hj_defaultThemeDic;
        }
    }
    
    id content = [dic valueForKeyPath:keyPath];
    return content;
}

//- (BOOL)HJ_isDefaultThemeController:(UIViewController *)vc {
//    NSArray *array = self.HJ_defaultThemeVCArr;
//    NSString *name = [NSString stringWithFormat:@"%@",[vc class]];
//    BOOL isDark = NO;
//    for (NSInteger i = 0; i < array.count; i++) {
//        NSString *subStr = array[i];
//        if ([name isEqualToString:subStr]) {
//            isDark = YES;
//            break;
//        }
//    }
//    return isDark;
//}

- (NSDictionary *)hj_currentThemeDic {
    if (!_hj_currentThemeDic) {
        _hj_currentThemeDic = @{}.mutableCopy;
    }
    return _hj_currentThemeDic;
}

-(NSDictionary *)hj_defaultThemeDic {
    if (!_hj_defaultThemeDic) {
        _hj_defaultThemeDic = @{}.mutableCopy;
    }
    return _hj_defaultThemeDic;
}

-(NSMutableDictionary *)hj_themeDic {
    if (!_hj_themeDic) {
        _hj_themeDic = @{}.mutableCopy;
    }
    return _hj_themeDic;
}

@end
