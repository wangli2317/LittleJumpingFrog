//
//  FMDataManager.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/4/21.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMDataManager.h"
#import "FMNetManager.h"
#import "FMMusicModel.h"

@interface FMDataManager ()

@property (nonatomic, strong)YYCache *cache;

@end

@implementation FMDataManager

+ (instancetype)manager{
    static  FMDataManager * dataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[FMDataManager alloc]init];
        dataManager.cache = [[YYCache alloc]initWithName:@"FMDataManager"];
    });
    return dataManager;
}

- (void)setValue:(id)object ForKey:(NSString *)key{
    [self.cache setObject:object forKey:key];
}

- (void)removeForKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)setString:(NSString *)string ForKey:(NSString *)key{
    [self.cache setObject:string forKey:key];
}

- (id)getValueForKey:(NSString *)key{
    id object = [self.cache objectForKey:key];
    return object;
}

- (id)getValueForKey:(NSString *)key defvalue:(id)defvalue{
    id object = [self.cache objectForKey:key];
    return object?object:defvalue;
}

- (void)getRankListSuccess:(void (^)(id data))success
                    failed:(void (^)(NSString * message)) failed{
    
    NSDictionary *params = FMParams(@"method":@"baidu.ting.billboard.billCategory",@"kflag":@"1");
    
    [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
        
        NSDictionary *dataJson = data;
        
        NSArray *modelArray = [NSArray modelArrayWithClass:NSClassFromString(@"FMRankListModel") json:dataJson[@"content"]];
        
        if (success) {
            success([modelArray modelCopy]);
        }
        
    } failed:^(NSString * _Nonnull message) {
        
        if (failed) {
            failed(message);
        }
        
    }];
}

- (void)getHotSearchesSuccess:(void (^)(id data))success
                       failed:(void (^)(NSString * message)) failed{
    NSDictionary *params =  FMParams(@"method":@"baidu.ting.search.hot",@"page_num":@"15");
    
    [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
        NSMutableArray *hotSeaches = [NSMutableArray array];
        
        for (NSDictionary *dict in data[@"result"]) {
            [hotSeaches addObject:dict[@"word"]];
        }
        
        if (success) {
            success(hotSeaches);
        }

    } failed:^(NSString * _Nonnull message) {
        
        if (failed) {
            failed(message);
        }
    }];
    
}

- (void)getSongMenuWithPage:(NSInteger)page
                    Success:(void (^)(NSArray * modelArray))success
                     failed:(void (^)(NSString * message)) failed{
    NSDictionary *params =  FMParams(@"method":@"baidu.ting.diy.gedan",@"page_no":[NSString stringWithFormat:@"%ld",page],@"page_size":@"30");
    
    [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
        
        NSArray *modelArray = [NSArray modelArrayWithClass:NSClassFromString(@"FMPublicMusictablesModel") json:data[@"content"]];
        
        if (success) {
            success(modelArray);
        }
    } failed:^(NSString * _Nonnull message) {
        if (failed) {
            failed(message);
        }
    }];
}

- (void)getSongListWithListid:(NSString *)listid
                      Success:(void (^)(id data))success
                       failed:(void (^)(NSString * message)) failed{
    NSDictionary *params =   FMParams(@"method":@"baidu.ting.diy.gedanInfo",@"listid":listid);
    
    [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
        
        if (success) {
            success(data);
        }
    } failed:^(NSString * _Nonnull message) {
        if (failed) {
            failed(message);
        }
    }];
}


- (void)getPublicListWithSongId:(NSString *)songId
                        Success:(void (^)(FMMusicModel * musicEntity))success
                         failed:(void (^)(NSString * message)) failed{
    
    NSArray *localModelArray = [FMMusicModel objectsWhere:[NSString stringWithFormat:@"WHERE songId='%@'",songId] arguments:nil];
    
    if (localModelArray.count > 0) {
        if (success) {
            success(localModelArray.firstObject);
        }
    }else{
        NSDictionary *params =   @{@"songIds":songId};
        
        [[FMNetManager manager] getWithUrl:FMMusic params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
            
            NSMutableArray *arrayM = data[@"data"][@"songList"];
            
            FMMusicModel *musicEntity = [FMMusicModel modelWithJSON:arrayM.firstObject];
            
            [musicEntity save];
            
            if (success) {
                success(musicEntity);
            }
            
        } failed:^(NSString * _Nonnull message) {
            if (failed) {
                failed(message);
            }
        }];
    
    }
}

- (void)getRankSongListWithOffset:(NSInteger)offset
                             type:(NSString *)type
                          Success:(void (^)(id data))success
                           failed:(void (^)(NSString * message)) failed{
    NSDictionary *params =  FMParams(@"method":@"baidu.ting.billboard.billList",@"offset":@(offset),@"size":@"30",@"type":type);
    
    [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
        
        if (success) {
            success(data);
        }
    } failed:^(NSString * _Nonnull message) {
        if (failed) {
            failed(message);
        }
    }];
    
}

- (void)downLoadMp3WithUrl:(NSString *)url
               Success:(void (^)(id data))success
                failed:(void (^)(NSString * message)) failed
              progress:(void (^)(CGFloat progress))progress{
    [[FMNetManager manager]downloadWithUrl:url success:^(id  _Nonnull data, NSString * _Nonnull message) {
        if (success) {
            success(data);
        }
    } failed:^(NSString * _Nonnull message) {
        if (failed) {
            failed(message);
        }
    } progress:^(CGFloat downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    }];
}
@end
