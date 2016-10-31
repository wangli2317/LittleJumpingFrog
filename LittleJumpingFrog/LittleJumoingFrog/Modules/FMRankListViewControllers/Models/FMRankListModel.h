//
//  FMRankListModel.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/18.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRankListModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,assign) NSString *type;
@property (nonatomic ,copy) NSString *comment;
@property (nonatomic ,copy) NSString *pic_s444;
@property (nonatomic ,copy) NSString *pic_s260;
@property (nonatomic ,strong) NSArray *content;
@end
