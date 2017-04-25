//
//  FMPublicMusictablesModel.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <GYDataCenter.h>

@interface FMPublicMusictablesModel : GYModelObject
@property (nonatomic, copy) NSString *listid;
@property (nonatomic ,copy) NSString *album_id;
@property (nonatomic, copy) NSString *listenum;
@property (nonatomic, copy) NSString *title;
@property (nonatomic ,copy) NSString *pic_big;
@property (nonatomic ,copy) NSString *author;
@property (nonatomic, copy) NSString *pic_300;
@end
