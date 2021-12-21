//
//  NSObject+HWSwitchCase.m
//  TestApp
//
//  Created by liuhaiwei on 2021/12/14.
//

#import "NSObject+HWSwitchCase.h"

const double  eps = 1e-8;
#define FEQUAL(a,b) (fabs((a) - (b)) < eps)

@implementation NSObject (HWSwitchCase)

- (void)switchInCases:(NSDictionary<id<NSCopying>,HWCaseBlock> *)cases {
    [self switchInCases:cases withDefault:nil];
}

- (void)switchInCases:(NSDictionary<id<NSCopying>,HWCaseBlock> *)cases withDefault:(HWCaseBlock)defaultBlock {
    NSAssert([self conformsToProtocol:@protocol(NSCopying)], @"must confirm to <NSCopying>");
    HWCaseBlock caseBlock = nil;
    
    if ([self isKindOfClass:[NSNumber class]]) {
        NSNumber *numKey = (NSNumber *)self;
        NSNumber *numInDic = [self findEquivalentNumber:numKey inDictionary:cases];
        if (numInDic) {
            caseBlock = cases[numInDic];
        }
    } else {
        caseBlock = cases[(id<NSCopying>)self];
    }
    
    if (caseBlock) {
        caseBlock();
    } else if (defaultBlock) {
        defaultBlock();
    }
}

- (NSNumber *)findEquivalentNumber:(NSNumber *)num inDictionary:(NSDictionary *)dic {
    double doubleKey = [num doubleValue];
    for (NSNumber *numIndic in dic.allKeys) {
        if ([numIndic isKindOfClass:[NSNumber class]]) {
            double doubleIndic = [numIndic doubleValue];
            if (FEQUAL(doubleIndic, doubleKey)) {
                return numIndic;
            }
        }
    }
    return nil;
}

@end
