//
//  FMLrcModel.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMLrcModel : NSObject
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) NSString *text;
- (instancetype)initWithLrcString:(NSString *)lrcString;
+ (instancetype)lrcModelWithLrcString:(NSString *)lrcString;
@end
