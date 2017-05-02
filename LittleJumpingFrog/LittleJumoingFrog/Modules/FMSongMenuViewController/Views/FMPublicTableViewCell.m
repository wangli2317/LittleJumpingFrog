//
//  FMPublicTableViewCell.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPublicTableViewCell.h"

#import "FMPublicCellMenuItemButton.h"

#import "FMPublicCellIconModel.h"
#import "FMPublicSongDetailModel.h"

#import <NAKPlaybackIndicatorView.h>
#import <POP.h>

#import "UIFont+Fonts.h"

@interface FMPublicTableViewCell ()
@property (nonatomic ,weak  ) UIView                   *mainView;
@property (nonatomic ,weak  ) UILabel                  *numLabel;
@property (nonatomic ,weak  ) UILabel                  *titleLabel;
@property (nonatomic ,weak  ) UILabel                  *authorLabel;
@property (nonatomic ,weak  ) UILabel                  *album_titleLabel;
@property (nonatomic ,weak  ) NAKPlaybackIndicatorView *indicatorView;
@property (nonatomic ,weak  ) UIView                   *menuView;
@property (nonatomic ,assign) BOOL                     isLoadedMenu;
@property (nonatomic ,strong) NSArray                  *cellMenuItemArray;

@property (nonatomic, strong) UIView                   *lineView;
@property (nonatomic, strong) UIView                   *rectView;

@end


@implementation FMPublicTableViewCell

static NSInteger ItemPadding = 10;
static NSInteger ItemNum = 5;

#pragma mark - setter
- (NAKPlaybackIndicatorViewState)indicatorViewState{
    return self.indicatorView.state;
}

- (void)setIndicatorViewState:(NAKPlaybackIndicatorViewState)indicatorViewState{
    self.indicatorView.state = indicatorViewState;
    self.numLabel.hidden = (indicatorViewState != NAKPlaybackIndicatorViewStateStopped);
    
    
}

- (NSArray *)cellMenuItemArray{
    if (!_cellMenuItemArray) {
        _cellMenuItemArray = [FMPublicCellIconModel CellMenuItemArray];
    }
    return _cellMenuItemArray;
}

- (void)setDetailModel:(FMPublicSongDetailModel *)detailModel{
    _detailModel = detailModel;
    
    self.numLabel.text =  [NSString stringWithFormat:@"%02ld.",(long)_detailModel.num];

    self.titleLabel.text = _detailModel.title;
    self.authorLabel.text = [NSString stringWithFormat:@"%@    %@",_detailModel.author,_detailModel.album_title];
}

#pragma mark - setUpCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //不设置会全部显示为下拉菜单
        self.layer.masksToBounds      = YES;
        self.clipsToBounds            = YES;
        self.selectionStyle           = UITableViewCellEditingStyleNone;
        [self setUpMainView];
        [self setUpButtonAndLine];
        [self setUpIndicator];
        self.menuView                 = [FMCreatTool viewWithView:self.mainView];
        self.menuView.backgroundColor = [UIColor clearColor];
        self.tintColor                = FMTintColor;
        
    }
    return self;
}

- (void)setUpMainView{
    self.mainView              = [FMCreatTool viewWithView:self];

    self.numLabel              = [FMCreatTool labelWithView:self.mainView];
    self.numLabel.textColor    = [[UIColor redColor] colorWithAlphaComponent:0.65f];
    self.numLabel.font         = [UIFont fontWithName:@"GillSans-Italic" size:16.f];

    self.titleLabel            = [FMCreatTool labelWithView:self.contentView];
    self.titleLabel.textColor  = [[UIColor blackColor] colorWithAlphaComponent:0.65f];
    self.titleLabel.font       = [UIFont HeitiSCWithFontSize:16.f];

    self.authorLabel           = [FMCreatTool labelWithView:self.mainView];
    self.authorLabel.font      = FMMiddleFont;
    self.authorLabel.textColor = FMTextColor;
}

- (void)setUpButtonAndLine{
    self.menuButton = [FMCreatTool buttonWithView:self.mainView];
    [self.menuButton setImage:[[UIImage imageNamed:@"icon_ios_more_tiny"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpIndicator{
    NAKPlaybackIndicatorView *indicator = [[NAKPlaybackIndicatorView alloc] init];
    [self.mainView addSubview:indicator];
    self.indicatorView                  = indicator;
    self.indicatorView.tintColor        = FMRandomColor;
    UITapGestureRecognizer *tap         = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIndicatorView)];
    [self.indicatorView addGestureRecognizer:tap];
}

#pragma mark - layoutCell
- (void)layoutSubviews{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(getScreenWidth());
        make.height.mas_equalTo(100);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).offset(FMHorizontalSpacing);;
        make.top.equalTo(self.mainView.mas_top).offset(FMVerticalSpacing);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).offset(5);
        make.top.equalTo(self.mainView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.mas_right).offset(FMCommonSpacing);
        make.top.equalTo(self.mainView.mas_top).offset(FMVerticalSpacing);
        make.right.equalTo(self.menuButton.mas_left);
        make.bottom.equalTo(self.authorLabel.mas_top);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.bottom.equalTo(self.menuView.mas_top).offset(-1 * FMVerticalSpacing);
    }];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.numLabel.mas_centerY);
        make.right.equalTo(self.mainView.mas_right).offset(-1 * FMHorizontalSpacing);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    

    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.mas_top).offset(50);
        make.left.and.right.equalTo(self.mainView);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - reuseCell
+ (instancetype)publicTableViewCellcellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"publicCell";
    FMPublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FMPublicTableViewCell alloc] initWithFrame:CGRectMake(0, 0, getScreenWidth(), 50)];
    }
    return cell;
}

#pragma mark - creatCellMenu
- (void)setUpCellMenu{
    if (!self.isLoadedMenu) {
        CGFloat ItemWidth = (getScreenWidth() - ItemPadding * (ItemNum + 1)) / ItemNum;
        __weak __typeof(self) weakSelf = self;
        for (NSInteger i = 0; i < ItemNum; i++) {
            FMPublicCellIconModel *iconModel   = self.cellMenuItemArray[i];
            CGRect rect                        = CGRectMake(ItemPadding + (ItemPadding + ItemWidth) * i, 0, ItemWidth, 44);
            FMPublicCellMenuItemButton *button = [[FMPublicCellMenuItemButton    alloc] initWithFrame:rect model:iconModel];
            button.tag                         = i;
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.menuView addSubview:button];
        }
    }
    self.isLoadedMenu = YES;
}

#pragma mark - delegate
- (void)clickItem:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(clickCellMenuItemAtIndex:Cell:)]) {
        [self.delegate clickCellMenuItemAtIndex:button.tag Cell:self];
    }
}

- (void)clickMenuButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(clickButton:openMenuOfCell:)]) {
        NSLog(@"展开menu");
        self.isOpenMenu = !self.isOpenMenu;
        [self.delegate clickButton:button openMenuOfCell:self];
    }
}

- (void)clickIndicatorView{
    if ([self.delegate respondsToSelector:@selector(clickIndicatorView)]) {
        [self.delegate clickIndicatorView];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    if (self.highlighted) {
        
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration           = 0.1f;
        scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.mainView pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
    } else {
        
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness    = 20.f;
        [self.mainView pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}



- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIColor *color = [UIColor lightGrayColor];
    [color set];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 0.5;
    
    [aPath moveToPoint:CGPointMake(13,CGRectGetMaxY(rect)-0.5)];
    [aPath addLineToPoint:CGPointMake(getScreenWidth() - 13,CGRectGetMaxY(rect)-0.5)];
    
    [aPath stroke];
}



@end
