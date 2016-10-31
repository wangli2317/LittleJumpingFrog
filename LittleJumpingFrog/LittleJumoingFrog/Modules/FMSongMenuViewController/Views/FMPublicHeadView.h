//
//  FMPublicHeadView.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMPublicSonglistModel;

@interface FMPublicHeadView : UIView
- (void)setMenuList:(FMPublicSonglistModel *)listModel;
- (void)setNewAlbum:(FMPublicSonglistModel *)albumModel;
- (instancetype)initWithFullHead:(BOOL)full;
@end
