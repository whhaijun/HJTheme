//
//  DeallocBlockExecutor.h
//  DKNightVersion
//
//  Created by nathanwhy on 16/2/24.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJDeallocBlockExecutor : NSObject

+ (instancetype)executorWithDeallocBlock:(void (^)(void))deallocBlock;

@property (nonatomic, copy) void (^deallocBlock)();

@end
