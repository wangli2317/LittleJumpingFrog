//
//  FMBadgeView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/7.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMBadgeView.h"

@implementation FMBadgeView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = NO;
        
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        
        // 设置字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self sizeToFit];
        
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    
    // 判断badgeValue是否有内容
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) { // 没有内容或者空字符串,等于0
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.hidden = YES;
//            
//        });
        [GCDQueue executeInMainQueue:^{
             self.hidden = YES;
        }];
        
    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.hidden = NO;
//            
//        });
        [GCDQueue executeInMainQueue:^{
            self.hidden = NO;
        }];
        
    }
    
    UIImage *mainImage = [UIImage imageNamed:@"main_badge"];
    
    if ([badgeValue integerValue] > 99) {
        
        mainImage = [mainImage stretchableImageWithLeftCapWidth:mainImage.size.width * 0.5 topCapHeight:mainImage.size.height];
        [self setTitle:@"99+" forState:UIControlStateNormal];
        self.size = CGSizeMake(30, self.height);
    }else{
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self sizeToFit];
    }
    
    [self setBackgroundImage:mainImage forState:UIControlStateNormal];
    
    [self setImage:nil forState:UIControlStateNormal];

    
}


@end
