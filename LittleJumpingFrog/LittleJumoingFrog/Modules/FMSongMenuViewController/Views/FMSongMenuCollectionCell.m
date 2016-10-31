//
//  FMSongMenuCollectionCell.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMSongMenuCollectionCell.h"
#import "FMPublicMusictablesModel.h"
#import "LineBackgroundView.h"

@interface FMSongMenuCollectionCell ()
@property (nonatomic ,weak) UIImageView *picView;
@property (nonatomic ,weak) UILabel *titleLabel;
@end

@implementation FMSongMenuCollectionCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}


- (void)setSongMenu:(FMPublicMusictablesModel *)menu{
    
    __weak FMSongMenuCollectionCell *wself = self;
    
    [self.picView setImageWithURL:[NSURL URLWithString:menu.pic_300] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        wself.picView.alpha = 0;
        wself.picView.image = image;
        
        [UIView animateWithDuration:0.35f animations:^{
            
            wself.picView.alpha = 1.f;
        }];
    }];
    
    self.titleLabel.text = menu.title;
}
- (void)setNewSongAlbum:(FMPublicMusictablesModel *)newSong{
    
    __weak FMSongMenuCollectionCell *wself = self;
    [self.picView setImageWithURL:[NSURL URLWithString:newSong.pic_big] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        wself.picView.alpha = 0;
        wself.picView.image = image;
        
        [UIView animateWithDuration:0.35f animations:^{
            
            wself.picView.alpha = 1.f;
        }];
    }];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",newSong.author,newSong.title];
}

- (instancetype)init{
    if (self = [super init]) {
         [self setupCell];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupCell];
    
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupCell];

    }
    
    return self;
}

- (void)setupCell{
    
    self.selectionStyle      = UITableViewCellSelectionStyleNone;
    self.clipsToBounds       = YES;
    self.picView             = [FMCreatTool imageViewWithView:self.contentView];
    self.picView.contentMode = UIViewContentModeScaleAspectFill;
    self.picView.frame       = CGRectMake(0, -(getScreenHeight() / 1.7 - 250) / 2, getScreenWidth(), getScreenHeight() / 1.7);
    
    UIView *blackView         = [FMCreatTool viewWithView:self.contentView];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    blackView.frame           = CGRectMake(0, 250 - 30, getScreenWidth(), 30);
    
    LineBackgroundView *lineBackgroundView = [LineBackgroundView createViewWithFrame:blackView.frame lineWidth:4 lineGap:4 lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.1f]];
    [self.contentView addSubview:lineBackgroundView];
    
    {
        UIView *lineView         = [FMCreatTool viewWithView:self.contentView];
        lineView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        lineView.bottom          = lineBackgroundView.top;
        lineView.frame = CGRectMake(0, 0, getScreenWidth(), 0.5f);
    }
    
    {
        UIView *lineView         = [FMCreatTool viewWithView:self.contentView];
        lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        lineView.bottom          = lineBackgroundView.bottom;
        lineView.frame = CGRectMake(0, 0, getScreenWidth(), 0.5f);
    }
    
    self.titleLabel               = [FMCreatTool labelWithView:self.contentView];
    self.titleLabel.width        -= 10;
    self.titleLabel.textColor     = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.font          = [UIFont fontWithName:@"Heiti SC" size:13.f];
    self.titleLabel.frame         = lineBackgroundView.frame;
    

}

- (CGFloat)cellOffset{
    CGRect  centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY        = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter   = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height * 2;
    CGFloat offset    =  -offsetDig * (getScreenHeight() / 1.7 - 250) / 2;
    
    CGAffineTransform transY   = CGAffineTransformMakeTranslation(0, offset);
    self.picView.transform = transY;
    
    return offset;

}

- (void)cancelAnimation{
      [self.picView.layer removeAllAnimations];
}

@end
