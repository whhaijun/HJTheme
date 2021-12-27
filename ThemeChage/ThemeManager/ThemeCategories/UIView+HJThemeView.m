//
//  UIView+HJThemeView.m
//  HJPaaS
//
//  Created by admin on 2020/12/21.
//

#import "UIView+HJThemeView.h"
#import "NSObject+HJThemeObject.h"
#import <objc/runtime.h>
#import "HJThemeManager.h"

#define hj_stringFromSelector(SEL) NSStringFromSelector(@selector(SEL))


@implementation UIView (HJThemeView)

@dynamic hj_themeTintColor;
@dynamic hj_themeBackgroundColor;

- (void)setHj_themeStyle:(NSString *)hj_themeStyle {
    objc_setAssociatedObject(self, @selector(hj_themeStyle), hj_themeStyle, OBJC_ASSOCIATION_ASSIGN);
    if (hj_themeStyle.length > 0) {
        if (self.themes.count > 0) {
            
            NSMutableDictionary *themeDic = @{}.mutableCopy;
            [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSArray *contents = (NSArray *)obj;
                NSString *themeStyle = contents.lastObject;
                if (themeStyle != hj_themeStyle) {
                    NSArray *newContent = @[contents.firstObject,hj_themeStyle];
                    [themeDic setValue:newContent forKey:key];
                }
            }];
            
            [themeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.themes setValue:obj forKey:key];
            }];
            
            NSNotification *noti = [[NSNotification alloc] initWithName:HJ_ThemeUpdateNotification object:hj_themeStyle userInfo:nil];
            [self hj_themeUpdateMethod:noti];
        }
    }
}

- (NSString *)hj_themeStyle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHj_themeTintColor:(NSString *)hj_themeTintColor {
    if (hj_themeTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeTintColor" colorPath:hj_themeTintColor];
    }
}

- (void)setHj_themeBackgroundColor:(NSString *)hj_themeBackgroundColor {
    if (hj_themeBackgroundColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeBackgroundColor" colorPath:hj_themeBackgroundColor];
    }
}

- (void)hj_setThemeColorWithIvarName:(NSString *)ivarName colorPath:(NSString *)path {
    NSString *selector;
    if ([ivarName containsString:@"hj_theme"]) {
        selector = [ivarName stringByReplacingOccurrencesOfString:@"hj_theme" withString:@"set"];
    }
    else {
        NSAssert(selector != nil, @"属性名称不规范，不是 hj_theme+Ivar");
    }
    selector = [selector stringByAppendingFormat:@":"];
    NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
    [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
        [self performSelector:NSSelectorFromString(selector) withObject:color];
    }];
    
    [self.themes setValue:@[path,themeStyle] forKey:selector];
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, id obj, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selector);
        NSArray *datas = (NSArray *)obj;
        if (themeStyle == nil || themeStyle.length == 0) {
            themeStyle = datas.lastObject;
        }
        if ([selector containsString:@"Color"]) {
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:datas.firstObject themeStyle:themeStyle  colorCallBack:^(UIColor * _Nonnull color) {
                [self performSelector:sel withObject:color];
            }];
        }
        else {
            [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:datas.firstObject themeStyle:themeStyle  imageCallBack:^(UIImage * _Nonnull image) {
                [self performSelector:sel withObject:image];
            }];
        }
    }];
}

@end

@implementation UILabel (HJThemeLabel)

@dynamic hj_themeTextColor;
@dynamic hj_themeShadowColor;
@dynamic hj_themeHighlightedTextColor;

- (void)setHj_themeTextColor:(NSString *)hj_themeTextColor {
    if (hj_themeTextColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeTextColor" colorPath:hj_themeTextColor];
    }
}

- (void)setHj_themeShadowColor:(NSString *)hj_themeShadowColor {
    if (hj_themeShadowColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeShadowColor" colorPath:hj_themeShadowColor];
    }
}

- (void)setHj_themeHighlightedTextColor:(NSString *)hj_themeHighlightedTextColor {
    if (hj_themeHighlightedTextColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeHighlightedTextColor" colorPath:hj_themeHighlightedTextColor];
    }
}

- (void)setHj_themeAttributedText:(NSAttributedString *)hj_themeAttributedText {
    if (hj_themeAttributedText.length > 0) {
        NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
        self.attributedText = [self hj_attributedStringWithAttributedString:hj_themeAttributedText];
        [self.themes setValue:@[hj_themeAttributedText,themeStyle] forKey:hj_stringFromSelector(setAttributedText:)];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, id obj, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selector);
        __block id result;
        NSArray *datas = (NSArray *)obj;
//        NSString *themeStyle = datas.lastObject;
        if (themeStyle == nil || themeStyle.length == 0) {
            themeStyle = datas.lastObject;
        }
        if ([selector isEqualToString:@"setAttributedText:"]) {
            NSAttributedString *hj_themeAttributedText = datas.firstObject;
            result = [self hj_attributedStringWithAttributedString:hj_themeAttributedText];
            [self performSelector:sel withObject:result];
        }
        else {
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:datas.firstObject themeStyle:themeStyle  colorCallBack:^(UIColor * _Nonnull color) {
                result = color;
                [self performSelector:sel withObject:result];
            }];
        }
//        [self performSelector:sel withObject:result];
    }];
}

- (NSMutableAttributedString *)hj_attributedStringWithAttributedString:(NSAttributedString *)attributedString {
    __block NSMutableArray *marr = @[].mutableCopy;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:1 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        if (attrs[NSForegroundColorAttributeName]) {
            NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:attrs[NSForegroundColorAttributeName] themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
                NSDictionary *dic = @{NSForegroundColorAttributeName:color};
                [marr addObject:@[dic,NSStringFromRange(range)]];
            }];
        }
    }];
    for (NSArray *arr in marr) {
        [string addAttributes:arr.firstObject range:NSRangeFromString(arr.lastObject)];
    }
    return string;
}

@end

@implementation UITextField (HJThemeTextField)
@dynamic hj_themeTextColor;

- (void)setHj_themeTextColor:(NSString *)hj_themeTextColor {
    if (hj_themeTextColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeTextColor" colorPath:hj_themeTextColor];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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

@implementation UITextView (HJThemeTextView)
@dynamic hj_themeTextColor;

- (void)setHj_themeTextColor:(NSString *)hj_themeTextColor {
    if (hj_themeTextColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeTextColor" colorPath:hj_themeTextColor];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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

@implementation UIImageView (HJThemeImageView)
@dynamic hj_themeImage;

- (void)setHj_themeImage:(NSString *)hj_themeImage {
    if (hj_themeImage.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
            [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:hj_themeImage themeStyle:themeStyle imageCallBack:^(UIImage * _Nonnull image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }];
            [self.themes setValue:@[hj_themeImage,themeStyle] forKey:hj_stringFromSelector(setImage:)];
        });
    }
}
- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, id obj, BOOL * _Nonnull stop) {
            NSArray *datas = (NSArray *)obj;
            if (themeStyle == nil || themeStyle.length == 0) {
                themeStyle = datas.lastObject;
            }
            __block UIImage *result;
            [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:datas.firstObject themeStyle:themeStyle  imageCallBack:^(UIImage * _Nonnull image) {
                result = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = result;
                });
            }];
        }];
    });
}

@end

@implementation UIButton (HJThemeButton)

- (void)hj_themeSetImage:(NSString *)path forState:(UIControlState)state {
    if (path.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
            [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:path themeStyle:themeStyle imageCallBack:^(UIImage * _Nonnull image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:image forState:state];
                });
            }];
            
            NSString *key = [NSString stringWithFormat:@"%@", @(state)];
            NSMutableDictionary *dictionary = [self.themes valueForKey:key];
            if (!dictionary) {
                dictionary = [[NSMutableDictionary alloc] init];
            }
            [dictionary setValue:@[path,themeStyle] forKey:NSStringFromSelector(@selector(setImage:forState:))];
            [self.themes setValue:dictionary forKey:key];
        });
    }
}
- (void)hj_themeSetBackgroundImage:(NSString *)path forState:(UIControlState)state {
    if (path.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";

            [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:path themeStyle:themeStyle imageCallBack:^(UIImage * _Nonnull image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setBackgroundImage:image forState:state];
                });
            }];
            NSString *key = [NSString stringWithFormat:@"%@", @(state)];
            NSMutableDictionary *dictionary = [self.themes valueForKey:key];
            if (!dictionary) {
                dictionary = [[NSMutableDictionary alloc] init];
            }
            [dictionary setValue:@[path,themeStyle] forKey:NSStringFromSelector(@selector(setBackgroundImage:forState:))];
            [self.themes setValue:dictionary forKey:key];
        });
    }
}
- (void)hj_themeSetTitleColor:(NSString *)path forState:(UIControlState)state {
    if (path.length > 0) {
        NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
        [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
            [self setTitleColor:color forState:state];
        }];
        
        NSString *key = [NSString stringWithFormat:@"%@", @(state)];
        NSMutableDictionary *dictionary = [self.themes valueForKey:key];
        if (!dictionary) {
            dictionary = [[NSMutableDictionary alloc] init];
        }
        [dictionary setValue:@[path,themeStyle] forKey:NSStringFromSelector(@selector(setTitleColor:forState:))];
        [self.themes setValue:dictionary forKey:key];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary<NSString *, NSArray *> *dictionary = (NSDictionary *)obj;
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, NSArray *datas, BOOL * _Nonnull stop) {
                UIControlState state = [key integerValue];
                NSString *path = datas.firstObject;
//                NSString *themeStyle = datas.lastObject;
                if (themeStyle == nil || themeStyle.length == 0) {
                    themeStyle = datas.lastObject;
                }
                if ([selector isEqualToString:NSStringFromSelector(@selector(setTitleColor:forState:))]) {
                    [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
                        [self setTitleColor:color forState:state];
                    }];
                } else if ([selector isEqualToString:NSStringFromSelector(@selector(setBackgroundImage:forState:))]) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:path themeStyle:themeStyle  imageCallBack:^(UIImage * _Nonnull image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setBackgroundImage:image forState:state];
                            });
                        }];
                    });
                } else if ([selector isEqualToString:NSStringFromSelector(@selector(setImage:forState:))]) {
                   dispatch_async(dispatch_get_global_queue(0, 0), ^{
                       [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:path themeStyle:themeStyle  imageCallBack:^(UIImage * _Nonnull image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setImage:image forState:state];
                            });
                        }];
                   });
                }
            }];
        } else {
            SEL sel = NSSelectorFromString(key);
            NSArray *datas = (NSArray *)obj;
            NSString *path = datas.firstObject;
            NSString *themeStyle = datas.lastObject;
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle  colorCallBack:^(UIColor * _Nonnull color) {
                [self performSelector:sel withObject:color];
            }];
        }
    }];
}

@end


@implementation UISwitch (HJThemeSwitch)
@dynamic hj_themeOnTintColor;
@dynamic hj_themeThumbTintColor;

- (void)setHj_themeOnTintColor:(NSString *)hj_themeOnTintColor {
    if(hj_themeOnTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeOnTintColor" colorPath:hj_themeOnTintColor];
    }
}

- (void)setHj_themeThumbTintColor:(NSString *)hj_themeThumbTintColor {
    if(hj_themeThumbTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeThumbTintColor" colorPath:hj_themeThumbTintColor];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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


@implementation UISegmentedControl (HJThemeSegmented)
@dynamic hj_themeSelectedSegmentTintColor;

- (void)setHj_themeSelectedSegmentTintColor:(NSString *)hj_themeSelectedSegmentTintColor {
    if(hj_themeSelectedSegmentTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeSelectedSegmentTintColor" colorPath:hj_themeSelectedSegmentTintColor];
    }
}

- (void)hj_themeSetTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state {
    NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
    NSDictionary *newAttributes = [self hj_attributesWithAttributes:attributes];
    [self setTitleTextAttributes:newAttributes forState:state];
    
    NSString *key = [NSString stringWithFormat:@"%@", @(state)];
    NSMutableDictionary *dictionary = [self.themes valueForKey:key];
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    [dictionary setValue:@[attributes,themeStyle] forKey:NSStringFromSelector(@selector(setTitleTextAttributes:forState:))];
    [self.themes setValue:dictionary forKey:key];
    
}

- (NSDictionary *)hj_attributesWithAttributes:(NSDictionary<NSAttributedStringKey,id> *)attributes {
    __block NSMutableDictionary *mdic = @{}.mutableCopy;
    [attributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:NSForegroundColorAttributeName]) {
            NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:obj themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
                mdic[key] = color;
            }];
        }
        else {
            mdic[key] = obj;
        }
    }];
    return mdic;
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary<NSString *, NSArray *> *dictionary = (NSDictionary *)obj;
                        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, NSArray *datas, BOOL * _Nonnull stop) {
                            UIControlState state = [key integerValue];
                            NSDictionary *attributes = datas.firstObject;

                            if (themeStyle == nil || themeStyle.length == 0) {
                                themeStyle = datas.lastObject;
                            }
                            if ([selector isEqualToString:NSStringFromSelector(@selector(setTitleTextAttributes:forState:))]) {
                                NSDictionary *newAttributes = [self hj_attributesWithAttributes:attributes];
                                [self setTitleTextAttributes:newAttributes forState:state];
                            }
                        }];
        } else {
            SEL sel = NSSelectorFromString(key);
            NSArray *datas = (NSArray *)obj;
            NSString *path = datas.firstObject;
            NSString *themeStyle = datas.lastObject;
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle  colorCallBack:^(UIColor * _Nonnull color) {
                [self performSelector:sel withObject:color];
            }];
        }
    }];
}

@end



@implementation UISlider (HJThemeSlider)
@dynamic hj_themeThumbTintColor;
@dynamic hj_themeMinimumTrackTintColor;
@dynamic hj_themeMaximumTrackTintColor;

- (void)setHj_themeThumbTintColor:(NSString *)hj_themeThumbTintColor {
    if(hj_themeThumbTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeThumbTintColor" colorPath:hj_themeThumbTintColor];
    }
}

- (void)setHj_themeMaximumTrackTintColor:(NSString *)hj_themeMaximumTrackTintColor {
    if(hj_themeMaximumTrackTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeMaximumTrackTintColor" colorPath:hj_themeMaximumTrackTintColor];
    }
}

- (void)setHj_themeMinimumTrackTintColor:(NSString *)hj_themeMinimumTrackTintColor{
    if(hj_themeMinimumTrackTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeMinimumTrackTintColor" colorPath:hj_themeMinimumTrackTintColor];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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


@implementation CALayer (HJThemeLayer)

@dynamic hj_themeBackgroundColor;
@dynamic hj_themeBorderColor;
@dynamic hj_themeShadowColor;

- (void)setHj_themeStyle:(NSString *)hj_themeStyle {
    objc_setAssociatedObject(self, @selector(hj_themeStyle), hj_themeStyle, OBJC_ASSOCIATION_ASSIGN);
    if (hj_themeStyle.length > 0) {
        if (self.themes.count > 0) {
            
            NSMutableDictionary *themeDic = @{}.mutableCopy;
            [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSArray *contents = (NSArray *)obj;
                NSString *themeStyle = contents.lastObject;
                if (themeStyle != hj_themeStyle) {
                    NSArray *newContent = @[contents.firstObject,hj_themeStyle];
                    [themeDic setValue:newContent forKey:key];
                }
            }];
            
            [themeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.themes setValue:obj forKey:key];
            }];
            
            NSNotification *noti = [[NSNotification alloc] initWithName:HJ_ThemeUpdateNotification object:hj_themeStyle userInfo:nil];
            [self hj_themeUpdateMethod:noti];
        }
    }
}

- (NSString *)hj_themeStyle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHj_themeShadowColor:(NSString *)hj_themeShadowColor {
    if (hj_themeShadowColor.length > 0) {
        [self hj_setThemeCGColorWithIvarName:@"hj_themeShadowColor" colorPath:hj_themeShadowColor];
    }
}

- (void)setHj_themeBorderColor:(NSString *)hj_themeBorderColor {
    if (hj_themeBorderColor.length > 0) {
        [self hj_setThemeCGColorWithIvarName:@"hj_themeBorderColor" colorPath:hj_themeBorderColor];
    }
}

- (void)setHj_themeBackgroundColor:(NSString *)hj_themeBackgroundColor {
    if (hj_themeBackgroundColor.length > 0) {
        [self hj_setThemeCGColorWithIvarName:@"hj_themeBackgroundColor" colorPath:hj_themeBackgroundColor];
    }
}

- (void)hj_setThemeCGColorWithIvarName:(NSString *)ivarName colorPath:(NSString *)path {
    NSString *selector;
    if ([ivarName containsString:@"hj_theme"]) {
        selector = [ivarName stringByReplacingOccurrencesOfString:@"hj_theme" withString:@"set"];
    }
    else {
        NSAssert(selector != nil, @"属性名称不规范，不是 hj_theme+Ivar");
    }
    selector = [selector stringByAppendingFormat:@":"];
    NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
    [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
        [self performSelector:NSSelectorFromString(selector) withObject:color.CGColor];
    }];
    [self.themes setValue:@[path,themeStyle] forKey:selector];
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(key);
        NSArray *datas = (NSArray *)obj;
        NSString *path = datas.firstObject;
//        NSString *themeStyle = datas.lastObject;
        if (themeStyle == nil || themeStyle.length == 0) {
            themeStyle = datas.lastObject;
        }
        __block id result;
        [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:themeStyle colorCallBack:^(UIColor * _Nonnull color) {
            result = color.CGColor;
            [self performSelector:sel withObject:result];
        }];
        
    }];
}

@end

@implementation CAGradientLayer (HJThemeGradientLayer)
@dynamic hj_themeColors;

- (void)setHj_themeColors:(NSString *)hj_themeColors {
    if (hj_themeColors.length > 0) {
        __block NSMutableArray *cgcolors = @[].mutableCopy;
        NSString *themeStyle = self.hj_themeStyle?self.hj_themeStyle:@"";
        [[HJThemeManager sharedInstance] hj_getColorsWithKeyPath:hj_themeColors themeStyle:themeStyle colorCallBack:^(NSArray<UIColor *> *colors) {
            [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [cgcolors addObject:obj.CGColor];
            }];
        }];
        self.colors = cgcolors;
        [self.themes setValue:@[hj_themeColors,themeStyle] forKey:hj_stringFromSelector(setColors:)];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(key);
        NSArray *datas = (NSArray<NSString *> *)obj;
        NSArray *paths = datas.firstObject;
//        NSString *themeStyle = datas.lastObject;
        if (themeStyle == nil || themeStyle.length == 0) {
            themeStyle = datas.lastObject;
        }
        __block NSMutableArray *cgcolors = @[].mutableCopy;
        [[HJThemeManager sharedInstance] hj_getColorsWithKeyPath:paths themeStyle:themeStyle colorCallBack:^(NSArray<UIColor *> *colors) {
            [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [cgcolors addObject:obj.CGColor];
            }];
        }];
        
        id result = cgcolors;
        [self performSelector:sel withObject:result];
    }];
}

@end

@implementation UIBarAppearance (HJThemeBarAppearance)

@dynamic hj_themeBackgroundColor;
@dynamic hj_themeBackgroundImage;
@dynamic hj_themeShadowColor;
@dynamic hj_themeShadowImage;

- (void)setHj_themeBackgroundColor:(NSString *)hj_themeBackgroundColor {
    if (hj_themeBackgroundColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeBackgroundColor" colorPath:hj_themeBackgroundColor];
    }
}

- (void)setHj_themeShadowColor:(NSString *)hj_themeShadowColor {
    if (hj_themeShadowColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeShadowColor" colorPath:hj_themeShadowColor];
    }
}

- (void)setHj_themeBackgroundImage:(NSString *)hj_themeBackgroundImage {
    if (hj_themeBackgroundImage.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeBackgroundImage" colorPath:hj_themeBackgroundImage];
    }
}

- (void)setHj_themeShadowImage:(NSString *)hj_themeShadowImage {
    if (hj_themeShadowImage.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeShadowImage" colorPath:hj_themeShadowImage];
    }
}


- (void)hj_setThemeColorWithIvarName:(NSString *)ivarName colorPath:(NSString *)path {
    NSString *selector;
    if ([ivarName containsString:@"hj_theme"]) {
        selector = [ivarName stringByReplacingOccurrencesOfString:@"hj_theme" withString:@"set"];
    }
    else {
        NSAssert(selector != nil, @"属性名称不规范，不是 hj_theme+Ivar");
    }
    selector = [selector stringByAppendingFormat:@":"];
    if ([ivarName containsString:@"Color"]) {
        [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:path themeStyle:@"" colorCallBack:^(UIColor * _Nonnull color) {
            [self performSelector:NSSelectorFromString(selector) withObject:color];
        }];
    }
    else {
        [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:path themeStyle:@"" imageCallBack:^(UIImage * _Nonnull image) {
            [self performSelector:NSSelectorFromString(selector) withObject:image];
        }];
    }
    [self.themes setValue:@[path,@""] forKey:selector];
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
    __block NSString *themeStyle = noti.object;
    [self.themes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, id obj, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selector);
        NSArray *datas = (NSArray *)obj;
        if (themeStyle == nil || themeStyle.length == 0) {
            themeStyle = datas.lastObject;
        }
        if ([selector containsString:@"Color"]) {
            [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:datas.firstObject themeStyle:themeStyle  colorCallBack:^(UIColor * _Nonnull color) {
                [self performSelector:sel withObject:color];
            }];
        }
        else {
            [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:datas.firstObject themeStyle:themeStyle  imageCallBack:^(UIImage * _Nonnull image) {
                [self performSelector:sel withObject:image];
            }];
        }
    }];
}

@end


@implementation UITableView (HJThemeTableView)
@dynamic hj_themeSeparatorColor;
@dynamic hj_themeSectionIndexColor;
@dynamic hj_themeSectionIndexBackgroundColor;

- (void)setHj_themeSeparatorColor:(NSString *)hj_themeSeparatorColor {
    if (hj_themeSeparatorColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeSeparatorColor" colorPath:hj_themeSeparatorColor];
    }
}
- (void)setHj_themeSectionIndexColor:(NSString *)hj_themeSectionIndexColor {
    if (hj_themeSectionIndexColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeSectionIndexColor" colorPath:hj_themeSectionIndexColor];
    }
}

- (void)setHj_themeSectionIndexBackgroundColor:(NSString *)hj_themeSectionIndexBackgroundColor {
    if (hj_themeSectionIndexBackgroundColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeSectionIndexBackgroundColor" colorPath:hj_themeSectionIndexBackgroundColor];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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


@implementation UITabBarItem (HJThemeTabBarItem)
@dynamic hj_themeSelectedImage;
- (void)setHj_themeShadowImage:(NSString *)hj_themeSelectedImage {
    if (hj_themeSelectedImage.length > 0) {
        NSString *selector = @"setSelectedImage:";
        [[HJThemeManager sharedInstance] hj_getImageWithKeyPath:hj_themeSelectedImage themeStyle:@"" imageCallBack:^(UIImage * _Nonnull image) {
            [self performSelector:NSSelectorFromString(selector) withObject:image];
        }];
        [self.themes setValue:@[hj_themeSelectedImage,@""] forKey:selector];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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

@implementation UINavigationBar (HJThemeNavigationBar)
@dynamic hj_themeBarTintColor;

- (void)setHj_themeBarTintColor:(NSString *)hj_themeBarTintColor {
    if (hj_themeBarTintColor.length > 0) {
        [self hj_setThemeColorWithIvarName:@"hj_themeBarTintColor" colorPath:hj_themeBarTintColor];
    }
}

- (void)hj_themeUpdateMethod:(NSNotification *)noti {
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
