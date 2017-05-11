//
//  UIImage+DTSLocation.m
//  DTSmogi
//
//  Created by 王刚 on 16/12/14.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "UIImage+DTSLocation.h"

@implementation UIImage (DTSLocation)

+ (UIImage *)dts_imageInKit:(NSString *)imageName{
    
    NSString * bundlePath = [[DTSApplication application] getBundleName];
    NSString * bundleFillPath = [bundlePath stringByAppendingString:@"/"];
    NSString * name = [bundleFillPath stringByAppendingPathComponent:imageName];
    
    UIImage * image =  [UIImage imageWithContentsOfFile:name];
    
    return image;
}
@end
