//
//  FMCreatTool.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMCreatTool : NSObject
+ (UIView *)viewWithView:(UIView *)superView;
+ (UITableView *)tableViewWithView:(UIView *)superView;
+ (UIScrollView *)scrollViewWithView:(UIView *)superView;
+ (UIImageView *)imageViewWithView:(UIView *)superView;
+ (UIImageView *)imageViewWithView:(UIView *)superView size:(CGSize)size;

+ (UILabel *)labelWithView:(UIView *)superView;
+ (UILabel *)labelWithView:(UIView *)superView size:(CGSize)size;

+ (UIButton *)buttonWithView:(UIView *)superView;
+ (UIButton *)buttonWithView:(UIView *)superView image:(UIImage *)image state:(UIControlState)state;
+ (UIButton *)buttonWithView:(UIView *)superView image:(UIImage *)image state:(UIControlState)state size:(CGSize)size;
@end
