//
//  NSMutableAttributedString+StringAttribute.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMStringAttributeProtocol.h"

@interface NSMutableAttributedString (StringAttribute)

/**
 *  添加富文本对象
 *
 *  @param stringAttribute 实现了StringAttributeProtocol协议的对象
 */
- (void)addStringAttribute:(id <FMStringAttributeProtocol>)stringAttribute;

/**
 *  消除指定的富文本对象
 *
 *  @param stringAttribute 实现了StringAttributeProtocol协议的对象
 */
- (void)removeStringAttribute:(id <FMStringAttributeProtocol>)stringAttribute;


@end
