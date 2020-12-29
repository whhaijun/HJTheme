//
//  DeallocBlockExecutor.m
//  DKNightVersion
//
//  Created by nathanwhy on 16/2/24.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import "HJDeallocBlockExecutor.h"

@implementation HJDeallocBlockExecutor

+ (instancetype)executorWithDeallocBlock:(void (^)(void))deallocBlock {
    HJDeallocBlockExecutor *o = [HJDeallocBlockExecutor new];
    o.deallocBlock = deallocBlock;
    return o;
}

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
        self.deallocBlock = nil;
    }
}
@end
