//
//  FMRankSongListTableHeaderView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/31.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMRankSongListTableHeaderView.h"
#import "FMRankSonglistModel.h"

@interface  FMRankSongListTableHeaderView()

@property(nonatomic,weak)UIImageView *backGroundImageView;

@end

@implementation FMRankSongListTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backGroundImageView = [[UIImageView alloc]init];
        [self addSubview:backGroundImageView];
        self.backGroundImageView = backGroundImageView;
    }
    return self;
}

- (void)setSongListModel:(FMRankSonglistModel *)songListModel{
    _songListModel = songListModel;
    [self.backGroundImageView setImageURL:[NSURL URLWithString:songListModel.pic_s210]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backGroundImageView.frame = self.bounds;
}



@end
