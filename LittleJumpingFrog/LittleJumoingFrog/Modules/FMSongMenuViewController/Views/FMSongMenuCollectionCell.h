//
//  FMSongMenuCollectionCell.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMPublicMusictablesModel;

@interface FMSongMenuCollectionCell : UITableViewCell

- (void)setSongMenu:(FMPublicMusictablesModel *)menu;
- (void)setNewSongAlbum:(FMPublicMusictablesModel *)newSong;

- (CGFloat)cellOffset;

- (void)cancelAnimation;
@end
