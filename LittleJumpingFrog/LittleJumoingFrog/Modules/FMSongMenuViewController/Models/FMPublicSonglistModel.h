//
//  FMPublicSonglistModel.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMPublicSonglistModel : NSObject
@property (nonatomic, copy) NSString *pic_500;
@property (nonatomic, copy) NSString *listenum;
@property (nonatomic, copy) NSString *collectnum;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray *content;

@property (nonatomic ,copy) NSString *pic_radio;
@property (nonatomic ,copy) NSString *publishtime;
@property (nonatomic ,copy) NSString *info;
@property (nonatomic ,copy) NSString *author;
@end
