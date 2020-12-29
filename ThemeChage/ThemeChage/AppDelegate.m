//
//  AppDelegate.m
//  ThemeChage
//
//  Created by admin on 2020/12/21.
//  Copyright © 2020 HJ. All rights reserved.
//

#import "AppDelegate.h"
#import "HJThemeManager.h"
@interface AppDelegate ()<HJThemeProtocol>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [HJThemeManager sharedInstance].themeProtocol = self;
    [[HJThemeManager sharedInstance] switchThemeWithName:@"Light"];
    
    return YES;
}



- (NSDictionary *_Nonnull)getThemeDicWithName:(NSString *_Nonnull)name {
    return [self getDictFromJsonName:name];
}
/// 设置默认主题
- (NSDictionary *_Nonnull)getDefaultThemeDic {
    return [self getDictFromJsonName:@"Light"];
}

- (NSString *)getDarkThemeName {
    return @"Dark";
}

- (void)getImageForUrl:(NSString *_Nullable)url completeBlock:(void(^_Nullable)(UIImage *_Nullable image))completeBlock {
    if ([url containsString:@"http"]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                completeBlock(image);
            });
        });
    }
    else {
        completeBlock([UIImage imageNamed:url]);
    }
}

- (NSDictionary *)getDictFromJsonName:(NSString *)jsonName {
    NSString *pathUI = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *dataUI = [[NSData alloc] initWithContentsOfFile:pathUI];
    NSString *hintStr = [NSString stringWithFormat:@"设置的主题%@找不到，请检查",jsonName];
    NSAssert(dataUI != nil, hintStr);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataUI options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
