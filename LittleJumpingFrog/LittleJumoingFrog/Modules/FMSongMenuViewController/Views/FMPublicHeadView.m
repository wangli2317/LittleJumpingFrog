//
//  FMPublicHeadView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPublicHeadView.h"
#import "FMPublicSonglistModel.h"
#import "LineBackgroundView.h"

@interface FMPublicHeadView ()
@property (nonatomic ,weak) UIImageView *picView;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UILabel *tagLabel;
@property (nonatomic ,weak) UILabel *listenumLabel;

@property (nonatomic ,weak) UIButton *collectButton;
@property (nonatomic ,weak) UIButton *shareButton;
@property (nonatomic ,weak) UIButton *likeButton;
@property (nonatomic ,weak) UIButton *MenuButton;

@property (nonatomic ,weak) UILabel *descLabel;

@property (nonatomic ,strong) LineBackgroundView *lineBackgroundView;

@property (nonatomic ,assign) BOOL isFullImage;
@end

@implementation FMPublicHeadView

- (void)setMenuList:(FMPublicSonglistModel *)listModel{
    
    [self.picView setImageURL:[NSURL URLWithString:listModel.pic_500]];
    self.titleLabel.text = listModel.title;
    self.tagLabel.text = listModel.tag;
    self.listenumLabel.text = [NSString stringWithFormat:@"%@个听众  %@个粉丝",listModel.listenum,listModel.collectnum];
    self.descLabel.text = listModel.desc;
}
- (void)setNewAlbum:(FMPublicSonglistModel *)albumModel{
    
    [self.picView setImageURL:[NSURL URLWithString:albumModel.pic_radio]];
    self.titleLabel.text = albumModel.title;
    self.tagLabel.text = albumModel.author;
    self.listenumLabel.text = [NSString stringWithFormat:@"%@发行",albumModel.publishtime];
    self.descLabel.text = albumModel.info;
}

#pragma mark - setUp
- (instancetype)initWithFullHead:(BOOL)full{
    
    if (self = [super init]) {
        [self setUpHeadView];
        [self setUpButtons];
        [self setUpDescLabel];
        self.isFullImage = full;
        self.tintColor = FMTintColor;
        
    }
    return self;
}

- (void)setUpHeadView{
    
    self.picView        = [FMCreatTool imageViewWithView:self];
    
    LineBackgroundView *lineBackgroundView = [LineBackgroundView createViewWithFrame:CGRectMake(0, 100, getScreenWidth(), 100) lineWidth:4 lineGap:4 lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.1f]];
    [self addSubview:lineBackgroundView];
    self.lineBackgroundView = lineBackgroundView;
    
    {
        UIView *lineView         = [FMCreatTool viewWithView:lineBackgroundView];
        lineView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        lineView.bottom          = lineBackgroundView.top;
        lineView.frame = CGRectMake(0, 0, getScreenWidth(), 0.5f);
    }
    
    {
        UIView *lineView         = [FMCreatTool viewWithView:lineBackgroundView];
        lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        lineView.bottom          = lineBackgroundView.bottom;
        lineView.frame = CGRectMake(0, 0, getScreenWidth(), 0.5f);
    }
    
    
    
    self.titleLabel     = [FMCreatTool labelWithView:lineBackgroundView];
    self.titleLabel.font = FMBigFont;
    self.titleLabel.numberOfLines = 0;
    
    self.tagLabel       = [FMCreatTool labelWithView:lineBackgroundView];
    
    self.tagLabel.font  = FMMiddleFont;
    
    self.listenumLabel  = [FMCreatTool labelWithView:lineBackgroundView];
    
    self.listenumLabel.font = FMMiddleFont;
}

- (void)setUpButtons{
    self.collectButton  = [FMCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] state:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(clickCollectButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton    = [FMCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_export"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate ] state:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeButton     = [FMCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] state:UIControlStateNormal];
    [self.likeButton setImage:[[UIImage imageNamed:@"icon_ios_heart_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.MenuButton = [FMCreatTool buttonWithView:self image:[[UIImage imageNamed:@"icon_ios_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] state:UIControlStateNormal] ;
    [self.MenuButton addTarget:self action:@selector(clickMenuButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpDescLabel{
    self.descLabel      = [FMCreatTool labelWithView:self];
    self.descLabel.font = FMMiddleFont;
    self.descLabel.numberOfLines = 0;
}

#pragma mark - layout
- (void)layoutSubviews{
    [self layoutDescLabel];
    [self layoutButtons];
    
    [self layoutBigImageAndLabel];
//    self.isFullImage ? [self layoutBigImageAndLabel] : [self layoutSmallImageAndLabel];
    
}

- (void)layoutBigImageAndLabel{
    
    self.listenumLabel.textColor = [UIColor whiteColor];
    self.tagLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getScreenWidth(), getScreenWidth()));
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(-0.5 * getScreenWidth());
    }];
    
    [self.listenumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(FMHorizontalSpacing);
        make.bottom.equalTo(self.picView.mas_bottom).offset(-1 * FMCommonSpacing);
        make.height.mas_equalTo(getScreenWidth() * 0.5);
        make.height.mas_equalTo(20);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.listenumLabel);
        make.bottom.equalTo(self.listenumLabel.mas_top).offset(-0.5 * FMVerticalSpacing);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tagLabel.mas_top).offset(-0.5 * FMVerticalSpacing);
        make.left.equalTo(self.mas_left).offset(FMHorizontalSpacing);
        make.right.equalTo(self.mas_right).offset(-FMHorizontalSpacing);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.picView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titleLabel.mas_top).offset(-1 * FMVerticalSpacing);
    }];
    
}
- (void)layoutSmallImageAndLabel{
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(FMHorizontalSpacing + 10);
        make.left.equalTo(self.mas_left).offset(FMHorizontalSpacing);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-1 * FMHorizontalSpacing);
        make.width.equalTo(self.picView.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView.mas_top);
        make.left.equalTo(self.picView.mas_right).offset(FMHorizontalSpacing);
        make.right.equalTo(self.mas_right).offset(-FMHorizontalSpacing);
        make.height.mas_equalTo(40);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(FMVerticalSpacing);
        make.left.and.right.equalTo(self.titleLabel);
    }];
    
    [self.listenumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagLabel.mas_bottom).offset(FMVerticalSpacing);
        make.left.and.right.equalTo(self.tagLabel);
    }];
    
}

- (void)layoutButtons{
    [self.MenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.mas_right).offset(-1 * FMHorizontalSpacing);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-1 * FMHorizontalSpacing);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.MenuButton.mas_left).offset(-1 * FMHorizontalSpacing);
        make.bottom.equalTo(self.MenuButton.mas_bottom);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.likeButton.mas_left).offset(-1 * FMHorizontalSpacing);
        make.bottom.equalTo(self.MenuButton.mas_bottom);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.shareButton.mas_left).offset(-1 * FMHorizontalSpacing);
        make.bottom.equalTo(self.MenuButton.mas_bottom);
    }];
    
}

- (void)layoutDescLabel{
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(FMHorizontalSpacing);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-1 * FMHorizontalSpacing);
        make.height.mas_offset(60);
    }];
    
}

#pragma mark - clickButtons

- (void)clickCollectButton{
    
    NSLog(@"clickCollectButton");
    [FMPromptTool promptModeText:@"歌单已添加到播放列表" afterDelay:1.0];
}

- (void)clickShareButton{
    
    NSLog(@"clickShareButton");
    [FMPromptTool promptModeText:@"分享功能待完善中" afterDelay:1.0];
}

- (void)clickLikeButton{
    
    NSLog(@"clickLikeButton");
    [FMPromptTool promptModeText:@"歌单已收藏" afterDelay:1.0];
}

- (void)clickMenuButton{
    NSLog(@"clickMenuButton");
    [FMPromptTool promptModeText:@"抱歉，暂无详细信息" afterDelay:1.0];
}



@end
