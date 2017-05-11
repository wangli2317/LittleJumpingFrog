//
//  NSMutableAttributedString+StringAttribute.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "NSMutableAttributedString+StringAttribute.h"

@implementation NSMutableAttributedString (StringAttribute)

- (void)addStringAttribute:(id <FMStringAttributeProtocol>)stringAttribute {
    
    [self addAttribute:[stringAttribute attributeName]
                 value:[stringAttribute attributeValue]
                 range:[stringAttribute effectiveStringRange]];
}

- (void)removeStringAttribute:(id <FMStringAttributeProtocol>)stringAttribute {
    
    [self removeAttribute:[stringAttribute attributeName]
                    range:[stringAttribute effectiveStringRange]];
}

@end
