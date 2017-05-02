//
//  FMDataManager.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/4/21.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMMusicModel;

@interface FMDataManager : NSObject

+ (instancetype)manager;

- (void)setValue:(id)object ForKey:(NSString *)key;

- (void)removeForKey:(NSString *)key;

- (void)setString:(NSString *)string ForKey:(NSString *)key;

- (id  )getValueForKey:(NSString *)key;

- (id  )getValueForKey:(NSString *)key defvalue:(id)defvalue;

- (void)fetchDataFromServerWithDataMethod:(NSString *)dataMethod
                                     page:(NSInteger)page
                              otherParams:(NSMutableDictionary *)otherParams
                                  success:(void (^)(id data, NSInteger totalPage))success
                                   failed:(void (^)(NSString * message)) failed;

- (void)getRankListSuccess:(void (^)(id data))success
                    failed:(void (^)(NSString * message)) failed;

- (void)getHotSearchesSuccess:(void (^)(id data))success
                       failed:(void (^)(NSString * message)) failed;

- (void)getSongMenuWithPage:(NSInteger)page
                    Success:(void (^)(NSArray  * modelArray))success
                     failed:(void (^)(NSString * message)) failed;

- (void)getSongListWithListid:(NSString *)listid
                    Success:(void (^)(id data))success
                     failed:(void (^)(NSString * message)) failed;

- (void)getPublicListWithSongId:(NSString *)songId
                        Success:(void (^)(FMMusicModel * musicEntity))success
                         failed:(void (^)(NSString * message)) failed;

- (void)getRankSongListWithOffset:(NSInteger)offset
                             type:(NSString *)type
                          Success:(void (^)(id data))success
                           failed:(void (^)(NSString * message)) failed;

- (void)downLoadMp3WithUrl:(NSString *)url
                   Success:(void (^)(id data))success
                    failed:(void (^)(NSString * message)) failed
                  progress:(void (^)(CGFloat progress))progress;
@end
