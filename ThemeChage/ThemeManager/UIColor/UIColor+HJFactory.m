//
//  UIColor+Extension.m
//  HJmobilesecurities
//
//  Created by huzj on 15/3/23.
//  Copyright (c) 2015年 HJ. All rights reserved.
//

#import "UIColor+HJFactory.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HJThemeManager.h"

@implementation UIColor(HJFactory)

+ (UIColor *)mixColor1:(UIColor*)color1 color2:(UIColor *)color2 ratio:(CGFloat)ratio {
    if(ratio > 1)
        ratio = 1;
    const CGFloat * components1 = CGColorGetComponents(color1.CGColor);
    const CGFloat * components2 = CGColorGetComponents(color2.CGColor);
    
    CGFloat r = components1[0]*ratio + components2[0]*(1-ratio);
    CGFloat g = components1[1]*ratio + components2[1]*(1-ratio);
    CGFloat b = components1[2]*ratio + components2[2]*(1-ratio);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)hj_mainTextColor {
    return [self hj_colorFromColorKey:mainTextColorKey];
}

+ (UIColor *)hj_secondTextColor {
    return [self hj_colorFromColorKey:secondTextColorKey];
}
+ (UIColor *)hj_detailTextColor {
    return [self hj_colorFromColorKey:detailTextColorKey];
}
+ (UIColor *)hj_mainButtonBackgroundColor {
    return [self hj_colorFromColorKey:mainButtonBackgroundColorKey];
}
+ (UIColor *)hj_stockRiseColor {
    return [self hj_colorFromColorKey:stockRiseColorKey];
}
+ (UIColor *)hj_stockFallColor {
    return [self hj_colorFromColorKey:stockFallColorKey];
}
+ (UIColor *)hj_stockSameColor{
    return [self hj_colorFromColorKey:stockSameColorKey];
}
+ (UIColor *)hj_linkTextColor {
    return [self hj_colorFromColorKey:linkTextColorKey];
}
+ (UIColor *)hj_secondButtonBorderColor {
    return [self hj_colorFromColorKey:secondButtonBorderColorKey];
}
+ (UIColor *)hj_separateLineColor {
    return [self hj_colorFromColorKey:separateLineColorKey];
}
+ (UIColor *)hj_backgroundColor {
    return [self hj_colorFromColorKey:backgroundColorKey];
}

#pragma mark - systemColor
+ (UIColor *)hj_blackColor {
    return [self hj_colorFromColorKey:blackColorKey];
}
+ (UIColor *)hj_whiteColor {
    return [self hj_colorFromColorKey:whiteColorKey];
}
+ (UIColor *)hj_redColor {
    return [self hj_colorFromColorKey:redColorKey];
}
+ (UIColor *)hj_grayColor {
    return [self hj_colorFromColorKey:grayColorKey];
}
+ (UIColor *)hj_greenColor {
    return [self hj_colorFromColorKey:greenColorKey];
}
+ (UIColor *)hj_blueColor {
    return [self hj_colorFromColorKey:blueColorKey];
}
+ (UIColor *)hj_yellowColor {
    return [self hj_colorFromColorKey:yellowColorKey];
}
+ (UIColor *)hj_orangeColor {
    return [self hj_colorFromColorKey:orangeColorKey];
}
+ (UIColor *)hj_clearColor {
    return [self hj_colorFromColorKey:clearColorKey];
}


+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    if (hexString.length <= 0) {
        return nil;
    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    unsigned hexAlpha = 255;
    if (hexString.length == 8) {
        NSScanner *scanner = [NSScanner scannerWithString:[hexString substringToIndex:2]];
        [scanner scanHexInt:&hexAlpha];
        hexString = [hexString substringFromIndex:2];
    }
    return [self colorFromHexString:hexString alpha:hexAlpha / 255.f];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if (hexString.length <= 0) {
        return nil;
    }
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:MIN(alpha, 1.0)];
}

+ (UIColor *)hj_colorFromColorKey:(NSString *)keyPath {
    __block UIColor *HJColor;
    [[HJThemeManager sharedInstance] hj_getColorWithKeyPath:keyPath themeStyle:hj_defaultLightThemeKey colorCallBack:^(UIColor * _Nonnull color) {
        HJColor = color;
    }];
    return HJColor;
}

@end
