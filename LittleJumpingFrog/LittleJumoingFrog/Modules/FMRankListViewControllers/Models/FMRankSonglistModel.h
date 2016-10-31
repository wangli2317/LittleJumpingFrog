//
//  FMRankSonglistModel.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/31.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRankSonglistModel : NSObject

@property (nonatomic, copy  )NSString *comment;

@property (nonatomic, copy  )NSString *name;

@property (nonatomic, copy  )NSString *pic_s210;

@property (nonatomic, copy  )NSString *pic_s260;

@property (nonatomic, copy  )NSString *pic_s444;

@property (nonatomic, copy  )NSString *pic_s640;

@property (nonatomic, assign)BOOL       havemore;
@end
