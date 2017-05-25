//
//  FMPublicMusictablesScrollViewModel.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/25.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMBaseDTO.h"

@interface FMPublicMusictablesScrollViewModel : FMBaseDTO

@property (nonatomic, copy) NSString *listid;
@property (nonatomic ,copy) NSString *album_id;
@property (nonatomic, copy) NSString *listenum;
@property (nonatomic, copy) NSString *title;
@property (nonatomic ,copy) NSString *pic_big;
@property (nonatomic ,copy) NSString *author;
@property (nonatomic, copy) NSString *pic_300;

@end
