//
//  UIColor+Extension.h
//  HJmobilesecurities
//
//  Created by huzj on 15/3/23.
//  Copyright (c) 2015年 HJ. All rights reserved.
//

#import <UIKit/UIKit.h>


#define COLOR(r,g,b)                                ([UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1])
#define COLORA(r,g,b,a)                             ([UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a])

#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]
#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : (alphaValue)]


@interface UIColor(HJFactory)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)mixColor1:(UIColor*)color1 color2:(UIColor *)color2 ratio:(CGFloat)ratio;


+ (UIColor *)hj_mainTextColor;
+ (UIColor *)hj_secondTextColor;
+ (UIColor *)hj_detailTextColor;
+ (UIColor *)hj_mainButtonBackgroundColor;
+ (UIColor *)hj_stockRiseColor;
+ (UIColor *)hj_stockFallColor;
+ (UIColor *)hj_stockSameColor;
+ (UIColor *)hj_linkTextColor;
+ (UIColor *)hj_secondButtonBorderColor;
+ (UIColor *)hj_separateLineColor;
+ (UIColor *)hj_backgroundColor;

#pragma mark - systemColor
+ (UIColor *)hj_blackColor;
+ (UIColor *)hj_whiteColor;
+ (UIColor *)hj_redColor;
+ (UIColor *)hj_grayColor;
+ (UIColor *)hj_greenColor;
+ (UIColor *)hj_blueColor;
+ (UIColor *)hj_yellowColor;
+ (UIColor *)hj_orangeColor;
+ (UIColor *)hj_clearColor;

+ (UIColor *)hj_colorFromColorKey:(NSString *)keyPath;

@end
