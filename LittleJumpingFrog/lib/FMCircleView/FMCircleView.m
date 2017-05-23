//
//  FMCircleView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMCircleView.h"
#import "FMStringRangeManager.h"
#import "FMForegroundColorAttribute.h"
#import "FMFontAttribute.h"
#import "NSMutableAttributedString+StringAttribute.h"
#import "FMInfiniteRotationView.h"

@interface FMCircleView ()

@property (nonatomic, strong) UILabel      *label;

@property (nonatomic, strong) FMStringRangeManager  *rangeManager;

@end

@implementation FMCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rangeManager = [FMStringRangeManager new];
        
        self.label                = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textAlignment  = NSTextAlignmentCenter;
        self.label.attributedText = [self percentStringWithPercentValue:0.f];
        [self addSubview:self.label];
    }
    
    return self;
}


- (CGFloat)radianFromDegree:(CGFloat)degree {
    
    return ((M_PI * (degree))/ 180.f);
}



- (void)strokeEnd:(CGFloat)value animationType:(AHEasingFunction)func animated:(BOOL)animated duration:(CGFloat)duration {
    
    if (value <= 0) {
        
        value = 0;
        
    } else if (value >= 1) {
        
        value = 1.f;
    }
    
    
    // Label
    _label.attributedText = [self percentStringWithPercentValue:value];
}


+ (instancetype)circleViewWithFrame:(CGRect)frame lineWidth:(CGFloat)width lineColor:(UIColor *)color
                          clockWise:(BOOL)clockWise startAngle:(CGFloat)angle {
    
    FMCircleView *circleView = [[FMCircleView alloc] initWithFrame:frame];
    
    {
        FMInfiniteRotationView *rotateView = [[FMInfiniteRotationView alloc] initWithFrame:circleView.bounds];
        rotateView.speed                 = 0.95f;
        rotateView.clockWise             = YES;
        [rotateView startRotateAnimation];
        [circleView addSubview:rotateView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rotateView.bounds];
        imageView.image        = [UIImage dts_imageInKit:@"homework_submission_loading"];
        imageView.center       = rotateView.middlePoint;
        [rotateView addSubview:imageView];
    }
    
    return circleView;
}


- (NSMutableAttributedString *)percentStringWithPercentValue:(CGFloat)percent {
    
    self.rangeManager.content           = [NSString stringWithFormat:@"%.f%%", fabs(percent * 100)];
    self.rangeManager.parts[@"percent"] = @"%";
    NSMutableAttributedString *richString = [[NSMutableAttributedString alloc] initWithString:self.rangeManager.content];
    
    {
        FMForegroundColorAttribute *attribute = [FMForegroundColorAttribute new];
        attribute.color                     = UIColorFromRGB(0xffffff);
        attribute.effectRange               = self.rangeManager.contentRange;
        [richString addStringAttribute:attribute];
    }
    
    {
        FMForegroundColorAttribute *attribute = [FMForegroundColorAttribute new];
        attribute.color                     = UIColorFromRGB(0xffffff);
        attribute.effectRange               = [[self.rangeManager rangesFromPartName:@"percent" options:0].firstObject rangeValue];
        [richString addStringAttribute:attribute];
    }
    
    {
        FMFontAttribute *attribute = [FMFontAttribute new];
        attribute.font           = [UIFont systemFontOfSize:30.f];
        attribute.effectRange    = self.rangeManager.contentRange;
        [richString addStringAttribute:attribute];
    }
    
    {
        FMFontAttribute *attribute = [FMFontAttribute new];
        attribute.font           = [UIFont systemFontOfSize:15.f];
        attribute.effectRange    = [[self.rangeManager rangesFromPartName:@"percent" options:0].firstObject rangeValue];
        [richString addStringAttribute:attribute];
    }
    
    return richString;
}


@end
