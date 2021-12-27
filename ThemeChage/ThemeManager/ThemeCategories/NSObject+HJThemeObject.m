//
//  NSObject+HJThemeObject.m
//  HJPaaS
//
//  Created by admin on 2020/12/22.
//

#import "NSObject+HJThemeObject.h"
#import "NSObject+DeallocBlock.h"
#import <objc/runtime.h>
#import "HJThemeManager.h"

/// 去除警告
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static void *HJViewDeallocHelperKey;

@implementation NSObject (HJThemeObject)

@dynamic themes;


- (NSMutableDictionary<NSString *, id > *)themes {
    NSMutableDictionary<NSString *, id > *themes = objc_getAssociatedObject(self, @selector(themes));
    if (!themes) {
        @autoreleasepool {
            // Need to removeObserver in dealloc
            if (objc_getAssociatedObject(self, &HJViewDeallocHelperKey) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                id deallocHelper = [self addDeallocBlock:^{
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, &HJViewDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
        }

        themes = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(themes), themes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:HJ_ThemeUpdateNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hj_themeUpdateMethod:) name:HJ_ThemeUpdateNotification object:nil];
    }
    return themes;
}



@end



