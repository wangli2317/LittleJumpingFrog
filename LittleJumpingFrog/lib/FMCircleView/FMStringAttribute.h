//
//  FMStringAttribute.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMStringAttributeProtocol.h"

@interface FMStringAttribute : NSObject<FMStringAttributeProtocol>

/**
 *  富文本设置的生效范围
 */
@property (nonatomic) NSRange  effectRange;



@end
