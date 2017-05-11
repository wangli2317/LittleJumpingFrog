//
//  FMStringRangeManager.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMStringRangeManager.h"
#import "NSString+Range.h"

@interface FMStringRangeManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *>  *parts;
@property (nonatomic)         NSRange contentRange;

@end


@implementation FMStringRangeManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.parts = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSArray *)rangesFromPartName:(NSString *)partName options:(NSStringCompareOptions)mask {
    
    NSParameterAssert(partName);
    
    NSArray  *array = nil;
    NSString *part  = self.parts[partName];
    
    if (part) {
        
        array = [self.content rangesOfString:part options:0 serachRange:NSMakeRange(0, self.content.length)];
    }
    
    return array;
}

+ (instancetype)stringRangeManagerWithContent:(NSString *)content parts:(NSDictionary *)parts {
    
    FMStringRangeManager *manager = [[[self class] alloc] init];
    manager.content             = content;
    manager.parts               = [NSMutableDictionary dictionaryWithDictionary:parts];
    
    return manager;
}

- (NSRange)contentRange {
    
    return NSMakeRange(0, _content.length);
}


@end
