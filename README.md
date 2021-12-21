Swift中的switch case支持多种数据类型，而Objective-C只支持整形，因此总是会出现如下这种冗长的代码形式：

```
if ([str isEqualToString:a]) {
    do sth 4 a
} else if ([str isEqualToString:b]) {
    do sth 4 b
} else if ([str isEqualToString:c]) {
    do sth 4 c
} else if ([str isEqualToString:d]) {
    do sth 4 d
} else if ([str isEqualToString:e]) {
    do sth 4 e
}
```
通过NSDictionary + Block，可以实现支持多种数据类型的switch case逻辑，NSDictionary中的key可以用作case的输入值，只要符合`NSCopying`协议的数据类型即可；NSDictionary中的value可以用作对应case要执行的Block。实现如下：
```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HWCaseBlock)(void);

@interface NSObject (HWSwitch)

- (void)switchInCases:(NSDictionary<id<NSCopying>, HWCaseBlock> *)cases;
- (void)switchInCases:(NSDictionary<id<NSCopying>, HWCaseBlock> *)cases withDefault:(nullable HWCaseBlock)defaultBlock;

@end

NS_ASSUME_NONNULL_END
```

```
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
        caseBlock = cases[numInDic];
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

```

使用示例：

```
    NSString *str = @"a";
    [str switchInCases:@{
        @"a": ^{
        NSLog(@"A");
    },
        @"b": ^{
        NSLog(@"B");
    },
    } withDefault:^{
        NSLog(@"cannot match the case!");
    }];
// 打印：A    

    CGFloat floatNum = 1.1;
    NSNumber *num = @(floatNum);
    [num switchInCases:@{
        @(1.1): ^{
        NSLog(@"一点一");
    },
        @(2.2): ^{
        NSLog(@"二点二");
    }
    }];
// 打印：二点二
```
通过以上形式，NSString、NSNumber等多种数据类型，均可使用switch case逻辑，甚至自定义对象也可以，只要遵循`NSCopying`协议，可用作NSDictionary的key即可。同时由于支持了NSNumber类型，对于float、double、BOOL等整形外的其他基本数据类型，也可以使用switch case逻辑，只需要通过@()包裹成NSNumber即可（见上例），同时对于浮点类型的比较精度问题已经做了处理，可以放心使用。

[Git地址](https://github.com/HighwayLaw/HWSwitchCase)，欢迎一起讨论、完善。
