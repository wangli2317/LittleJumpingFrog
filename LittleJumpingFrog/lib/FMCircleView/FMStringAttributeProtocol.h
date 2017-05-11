//
//  FMStringAttributeProtocol.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMStringAttributeProtocol <NSObject>

#pragma mark - 必须实现
@required

/**
 *  属性名字
 *
 *  @return 属性名字
 */
- (NSString *)attributeName;

/**
 *  属性对应的值
 *
 *  @return 对应的值
 */
- (id)attributeValue;

@optional

#pragma mark - 可选实现
/**
 *  属性设置生效范围
 *
 *  @return 生效的范围
 */
- (NSRange)effectiveStringRange;

@end
