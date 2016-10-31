//
//  FMRankListCell.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/18.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMRankListCell.h"
#import "FMRankSongModel.h"


@interface FMRankListCell ()

@property (nonatomic ,weak) UIImageView *cellImageView;

@property (nonatomic ,weak) UIView *cellBackgroundView;
@end

@implementation FMRankListCell



- (void)setRankListImage:(NSString *)rankListImage{
    _rankListImage = rankListImage;
    [self.cellImageView setImageURL:[NSURL URLWithString:_rankListImage]];
}

- (instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        
        NSInteger count = array.count > 3 ? 3 : array.count;
        
        NSInteger imageHeight = getScreenWidth() / 3;
        CGFloat labelHeight = (imageHeight - (count - 1) * FMVerticalSpacing) / count;
        CGFloat labelWidth = getScreenWidth() - imageHeight - count * FMVerticalSpacing;
        
        self.cellBackgroundView = [FMCreatTool viewWithView:self.contentView];
        self.cellBackgroundView.backgroundColor = [UIColor whiteColor];
        
        self.cellImageView = [FMCreatTool imageViewWithView:self.cellBackgroundView];
        self.cellImageView.frame = CGRectMake(0, 0, imageHeight, imageHeight);

        for (int i = 0; i < count; ++i) {
            NSDictionary *dict = [array objectAtIndex:i];
            
            FMRankSongModel *song = [FMRankSongModel modelWithJSON:dict];
            UILabel *label = [FMCreatTool labelWithView:self.cellBackgroundView];
            label.frame = CGRectMake(imageHeight + FMVerticalSpacing, (FMVerticalSpacing + labelHeight) * i, labelWidth, labelHeight);
            label.text = [NSString stringWithFormat:@"%ld. %@ - %@",(long)i + 1,song.title,song.author];
            label.font = FMBigFont;
            
        }

    }
    return self;
}

+ (instancetype)rankCellWithTableView:(UITableView *)tableView songInfoArray:(NSArray *)info{
    
    static NSString *ID = @"rankCell";
    FMRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FMRankListCell alloc] initWithArray:info];
    }
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.cellBackgroundView.frame = CGRectMake(FMVerticalSpacing, FMVerticalSpacing, getScreenWidth() - 2 * FMVerticalSpacing, getScreenWidth() / 3);
}


@end
