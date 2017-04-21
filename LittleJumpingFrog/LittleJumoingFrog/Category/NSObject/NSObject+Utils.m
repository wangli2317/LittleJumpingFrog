//
//  NSObject+Utils.m
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject (Utils)

- (BOOL) isEmpty{
    return (!self ||
            self == nil ||
            self == [NSNull null] ||
            ([self isKindOfClass:[NSString class]]&&[(NSString*)self isEqualToString:@"0"])||
            ([self isKindOfClass:[NSString class]]&&[(NSString*)self isEqualToString:@"nil"])||
            ([self isKindOfClass:[NSDictionary class]]&&([(NSDictionary*)self count]==0))||
            ([self isKindOfClass:[NSString class]]&&[(NSString*)self isEqualToString:@""]) ||
            ([self isKindOfClass:[NSMutableArray class]] && [(NSMutableArray *)self count] == 0)||
            ([self isKindOfClass:[NSArray class]] && [(NSArray *)self count] == 0) );
}


/*检测对象是否存在该属性*/
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName{
    unsigned int outCount, i;

    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *array = [window subviews] ;
    if (!array.count) {
        return nil;
    }
    UIView *frontView = [array objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



@end
