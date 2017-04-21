//
//  NSObject+Utils.h
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)

/**判断是否为空*/
- (BOOL) isEmpty;

/*检测对象是否存在该属性*/
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName;

+ (UIViewController *)getCurrentVC;
@end
