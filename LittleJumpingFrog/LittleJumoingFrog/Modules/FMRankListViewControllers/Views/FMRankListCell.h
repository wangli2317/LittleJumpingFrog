//
//  FMRankListCell.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/18.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRankListCell : UITableViewCell

@property (nonatomic ,copy) NSString *rankListImage;

+ (instancetype)rankCellWithTableView:(UITableView *)tableView songInfoArray:(NSArray *)info;
@end
