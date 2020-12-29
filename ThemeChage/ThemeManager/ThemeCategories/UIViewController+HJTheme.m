//
//  UIViewController+HJTheme.m
//  ThemeChage
//
//  Created by HJ on 2020/12/29.
//  Copyright © 2020 HJ. All rights reserved.
//

#import "UIViewController+HJTheme.h"
#import <objc/runtime.h>
#import "HJThemeManager.h"
@implementation UIViewController (HJTheme)
+(void)load {
    [self swizzleSEL:@selector(traitCollectionDidChange:) withSEL:@selector(hj_traitCollectionDidChange:)];
    
    [self swizzleSEL:@selector(viewDidLoad) withSEL:@selector(hj_viewDidLoad)];
}

//- (void)hj_viewDidLoad {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hj_themeUpdateMethod:) name:HJ_ThemeUpdateNotification object:nil];
//}


- (void)hj_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    //创建动态 color
    if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == 2) {
            NSString *themeName = [[HJThemeManager sharedInstance].themeProtocol getDarkThemeName];
            [[HJThemeManager sharedInstance] switchThemeWithName:themeName];
        }
        else {
            [[HJThemeManager sharedInstance] switchThemeWithName:hj_defaultLightThemeKey];
        }
    } else {
        NSLog(@"不是iOS13版本不需要暗黑模式");
    }
}


+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}


@end
