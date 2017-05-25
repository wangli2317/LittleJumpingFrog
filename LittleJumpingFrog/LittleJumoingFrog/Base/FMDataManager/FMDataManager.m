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
#import "FMPublicMusictablesModel.h"
#import "FMPublicMusictablesScrollViewModel.h"

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

- (void)fetchDataFromServerWithDataMethod:(NSString *)dataMethod page:(NSInteger)page otherParams:(NSMutableDictionary *)otherParams success:(void (^)(id data, NSInteger totalPage))success failed:(void (^)(NSString * message)) failed{
    
    SEL aSelector = NSSelectorFromString(dataMethod);
    
    if([self respondsToSelector:aSelector]) {
        
        NSLog(@"fetchDataFromServerWithDataMethod success :%@",dataMethod);
        
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:aSelector]];
        [inv setSelector:aSelector];
        [inv setTarget:self];
        
        [inv setArgument:&(page) atIndex:2];
        [inv setArgument:&(otherParams) atIndex:3];
        [inv setArgument:&(success) atIndex:4];
        [inv setArgument:&(failed) atIndex:5];
        
        [inv invoke];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DTSNOTIFI_RUNTIME_ERROR object:[NSString stringWithFormat:@"Method not exist: %@",dataMethod]];
        NSLog(@"fetchDataFromServerWithDataMethod failed :%@",dataMethod);
    }
}


- (void)getRankListSuccess:(void (^)(id data))success
                    failed:(void (^)(NSString * message)) failed{
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
        if (failed) {
            
            failed(@"当前无网络, 请检查您的网络状态");
            
        }
        
    }else{
    
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
}

- (void)getHotSearchesSuccess:(void (^)(id data))success
                       failed:(void (^)(NSString * message)) failed{
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
        if (failed) {
            
            failed(@"当前无网络, 请检查您的网络状态");
            
        }
        
    }else{
    
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
}

- (void) fetchSongMenuByPage:(NSInteger)page otherParams:(NSMutableDictionary *)otherParams success:(void (^)(id data))success failed:(void (^)(NSString * message)) failed{

    NSInteger num = 30;
    
    NSDictionary *params =  FMParams(@"method":@"baidu.ting.diy.gedan",@"page_no":[NSString stringWithFormat:@"%ld",page],@"page_size":[NSString stringWithFormat:@"%td",num]);
    
    [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
        
        NSArray *countentArray = data[@"content"];
        
        NSArray *modelArray = [NSArray modelArrayWithClass:[FMPublicMusictablesScrollViewModel class] json:countentArray];
        
        
        
//        for (NSDictionary *modelDictary in countentArray) {
//            FMPublicMusictablesScrollViewModel *model = [FMPublicMusictablesScrollViewModel modelWithJSON:modelDictary];
//            model.FM_CLASSTYPE = @"FMSongMenuScrollViewCell";
//            [modelArray addObject:model];
//        }
        
        if (success) {
            success(modelArray);
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
    
    NSInteger num = 30;
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
        if (page == 1) {
            NSInteger start =  (page - 1 )* num;
            NSArray *publicMusicArray = [FMPublicMusictablesModel objectsWhere:[NSString stringWithFormat:@" LIMIT %td,%td",start,num] arguments:nil];
            
            if (success) {
                success(publicMusicArray);
            }
        }else{
            
            if (failed) {
                
                failed(@"当前无网络, 请检查您的网络状态");
                
            }
        }
        
    }else{
    
        NSDictionary *params =  FMParams(@"method":@"baidu.ting.diy.gedan",@"page_no":[NSString stringWithFormat:@"%ld",page],@"page_size":[NSString stringWithFormat:@"%td",num]);
        
        [[FMNetManager manager] getWithUrl:FMUrl params:params success:^(id  _Nonnull data, NSString * _Nonnull message) {
            
            NSArray *countentArray = data[@"content"];
            
            NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:countentArray.count];
            
            for (NSDictionary *modelDictary in countentArray) {
                FMPublicMusictablesModel *model = [FMPublicMusictablesModel modelWithJSON:modelDictary];
                [model save];
                [modelArray addObject:model];
            }
            
            if (success) {
                success(modelArray);
            }
        } failed:^(NSString * _Nonnull message) {
            if (failed) {
                failed(message);
            }
        }];
    }
}

- (void)getSongListWithListid:(NSString *)listid
                      Success:(void (^)(id data))success
                       failed:(void (^)(NSString * message)) failed{
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
         
        
        if (failed) {
            
            failed(@"当前无网络, 请检查您的网络状态");
            
        }
        
    }else{
    
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
        
        if([DTSApplication application].status == CoreNetWorkStatusNone){
            
             
            
            if (failed) {
                
                failed(@"当前无网络, 请检查您的网络状态");
                
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
}

- (void)getRankSongListWithOffset:(NSInteger)offset
                             type:(NSString *)type
                          Success:(void (^)(id data))success
                           failed:(void (^)(NSString * message)) failed{
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
         
        
        if (failed) {
            
            failed(@"当前无网络, 请检查您的网络状态");
            
        }
        
    }else{
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
}

- (void)downLoadMp3WithUrl:(NSString *)url
               Success:(void (^)(id data))success
                failed:(void (^)(NSString * message)) failed
              progress:(void (^)(CGFloat progress))progress{
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
         
        
        if (failed) {
            
            failed(@"当前无网络, 请检查您的网络状态");
            
        }
        
    }else{
    
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
}

- (void)deleteMusicModelAndMp3WithSongID:(NSString *)songID
                                 Success:(void (^)(NSString * message))success
                                  failed:(void (^)(NSString * message)) failed{
    
    NSArray *localModelArray = [FMMusicModel objectsWhere:[NSString stringWithFormat:@"WHERE songId='%@'",songID] arguments:nil];
    
    if (localModelArray && localModelArray.count>0) {
        
        FMMusicModel *musicModel = localModelArray.firstObject;

        if (musicModel.fileSongLink && ![musicModel.fileSongLink isEqualToString:@""]) {
            
            BOOL del =  [[NSFileManager defaultManager] removeItemAtPath:musicModel.fileSongLink error:nil];
            
            NSLog(@"%@",del?@"删除成功":@"删除失败了");
            
            //无论删除是否成功 都要清除本地数据
            musicModel.fileSongLink = nil;
            [musicModel save];
            
            if (success) {
                success(@"删除成功");
            }
        }else{
            if (failed) {
                failed(@"本地并未下载数据，删除失败");
            }
        }
    }else{
    
        if (failed) {
            failed(@"本地并未下载数据，删除失败");
        }
        
    }

}
@end
