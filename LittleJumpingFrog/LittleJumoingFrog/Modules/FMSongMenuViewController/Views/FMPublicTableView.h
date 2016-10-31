//
//  FMPublicTableView.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMPublicTableView;
@protocol FMPublicTableViewDelegate <NSObject>

@optional
- (void)publickTableClickCell:(FMPublicTableView *)publicTableView;

@end

@interface FMPublicTableView : UITableView

@property (nonatomic , weak)id<FMPublicTableViewDelegate> publeTableDelegate;

- (void)setSongList:(NSMutableArray *)list songIds:(NSMutableArray *)ids listKey:(NSString *)listKey;
@end
