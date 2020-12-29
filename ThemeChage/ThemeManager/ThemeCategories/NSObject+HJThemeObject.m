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

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HJ_themeUpdateMethod:) name:HJ_ThemeUpdateNotification object:nil];
    }
    return themes;
}

- (void)HJ_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, id obj, BOOL * _Nonnull stop) {
            SEL sel = NSSelectorFromString(selector);
            NSArray *datas = (NSArray *)obj;
            if (themeStyle == nil || themeStyle.length == 0) {
                themeStyle = datas.lastObject;
            }
            if ([selector containsString:@"Color"]) {
                [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:datas.firstObject themeStyle:themeStyle  colorCallBack:^(UIColor * _Nonnull color) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSelectorOnMainThread:sel withObject:color waitUntilDone:YES];
                    });
                }];
            }
            else {
                [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:datas.firstObject themeStyle:themeStyle  imageCallBack:^(UIImage * _Nonnull image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self performSelector:sel withObject:image];
                        [self performSelectorOnMainThread:sel withObject:image waitUntilDone:YES];
                    });
                }];
            }
        }];
    });
}

@end



