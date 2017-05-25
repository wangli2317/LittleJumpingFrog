//
//  FMSongMenuScrollViewCell.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/25.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMSongMenuScrollViewCell.h"
#import "LineBackgroundView.h"
#import "FMPublicMusictablesScrollViewModel.h"

@interface FMSongMenuScrollViewCell ()

@property (nonatomic ,weak) UIImageView *picView;

@property (nonatomic ,weak) UILabel *titleLabel;

@end

@implementation FMSongMenuScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor                        = UIColorFromRGB(0xffffff);
        self.clipsToBounds       = YES;
        self.picView             = [FMCreatTool imageViewWithView:self];
        self.picView.contentMode = UIViewContentModeScaleAspectFill;
        self.picView.frame       = CGRectMake(0, -(getScreenHeight() / 1.7 - 250) / 2, getScreenWidth(), getScreenHeight() / 1.7);
        
        UIView *blackView         = [FMCreatTool viewWithView:self];
        blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        blackView.frame           = CGRectMake(0, 250 - 30, getScreenWidth(), 30);
        
        LineBackgroundView *lineBackgroundView = [LineBackgroundView createViewWithFrame:blackView.frame lineWidth:4 lineGap:4 lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.1f]];
        [self addSubview:lineBackgroundView];
        
        {
            UIView *lineView         = [FMCreatTool viewWithView:self];
            lineView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
            lineView.bottom          = lineBackgroundView.top;
            lineView.frame = CGRectMake(0, 0, getScreenWidth(), 0.5f);
        }
        
        {
            UIView *lineView         = [FMCreatTool viewWithView:self];
            lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
            lineView.bottom          = lineBackgroundView.bottom;
            lineView.frame = CGRectMake(0, 0, getScreenWidth(), 0.5f);
        }
        
        self.titleLabel               = [FMCreatTool labelWithView:self];
        self.titleLabel.width        -= 10;
        self.titleLabel.textColor     = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font          = [UIFont fontWithName:@"Heiti SC" size:13.f];
        self.titleLabel.frame         = lineBackgroundView.frame;
    
    }
    return self;
}

- (void)initView:(id)object frame:(CGRect)frame{
    [super initView:object frame:frame];
    
    FMPublicMusictablesScrollViewModel *model = self.object;
    
    @weakify(self)
    [self.picView setImageWithURL:[NSURL URLWithString:model.pic_300] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        @strongify(self)
        
        self.picView.alpha = 0;
        self.picView.image = image;
        
        [UIView animateWithDuration:0.35f animations:^{
            
            self.picView.alpha = 1.f;
        }];
    }];
    
    self.titleLabel.text = model.title;
}

+(CGFloat)calculateWidth:(id)object view:(FMScrollView *)view{
    return getScreenWidth();
}

+(CGFloat)calculateHeight:(id)object view:(FMScrollView *)view{
    return 250;
}


@end

