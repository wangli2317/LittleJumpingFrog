//
//  FMNetManager.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMNetManager.h"
#import <AFNetworking.h>
#import "NSObject+Utils.h"
#import "FMNetworkCache.h"

//超时时间
NSInteger const retry = 10;

@interface FMNetManager ()

@property (nonatomic , strong) AFHTTPSessionManager * client;

@property (nonatomic, strong ) NSMutableArray       *arrayOfTasks;

@end

@implementation FMNetManager

+ (instancetype)manager {
    static FMNetManager * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        instance.client = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        
        instance.client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //接收参数类型
        instance.client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/javascript",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        
        //设置超时时间
        instance.client.requestSerializer.timeoutInterval = retry;
        
    });
    
    return instance;
}




- (void)getWithUrl:(NSString*)urlStr
            params:(NSDictionary *)params
           success:(void (^)(id data,NSString * message))success
            failed:(void (^)(NSString* message))failed{
    
    if ([urlStr isEmpty]) return;
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
        if (failed) {
            failed(@"当前无网络, 请检查您的网络状态");
        }
    }else
    {
        [self.client.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.client GET:newUrlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (success) {
                success(responseObjectDictionary,[responseObjectDictionary objectForKey:@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failed) {
                failed(error.localizedDescription);
            }
        }];
    }
}

/**使用AFN进行GET请求,自动缓存*/
- (__kindof NSURLSessionTask *)getWithUrl:(NSString *)URL
                                   params:(NSDictionary *)params
                            responseCache:(void (^)(id data))responseCache
                                  success:(void (^)(id data))success
                                   failed:(void (^)(NSString* message))failed{
    
    //读取缓存
    responseCache!=nil ? responseCache([FMNetworkCache httpCacheForURL:URL parameters:params]) : nil;
    
    @weakify(self)
    NSURLSessionTask *sessionTask = [self.client GET:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        @strongify(self)
        
        [self.arrayOfTasks removeObject:task];
        
        NSDictionary *responseObjectDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //对数据进行异步缓存
        responseCache!=nil ? [FMNetworkCache setHttpCache:responseObjectDictionary URL:URL parameters:params] : nil;
        
        if (success) {
            success(responseObjectDictionary);
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        @strongify(self)
        
        [self.arrayOfTasks removeObject:task];
        
        if (failed) {
            failed(error.localizedDescription);
        }
        
    }];
    // 添加sessionTask到数组
    sessionTask ? [self.arrayOfTasks addObject:sessionTask] : nil ;
    
    return sessionTask;

}


- (void)postWithUrl:(NSString*)urlStr
             params:(NSDictionary *)params
            success:(void (^)(id data,NSString * message))success
             failed:(void (^)(NSString* message))failed {
    if ([urlStr isEmpty]) return;
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        
        if (failed) {
            failed(@"当前无网络, 请检查您的网络状态");
        }
    }else
    {
        [self.client.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.client POST:newUrlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if (success) {
                success(responseObjectDictionary,[responseObjectDictionary objectForKey:@"message"]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failed) {
                failed(error.localizedDescription);
            }
            
        }];
    }
}

- (__kindof NSURLSessionTask *)postWithUrl:(NSString *)URL
                                    params:(NSDictionary *)params
                             responseCache:(void (^)(id data))responseCache
                                   success:(void (^)(id data))success
                                    failed:(void (^)(NSString* message))failed{
    
    
    //读取缓存
    responseCache!=nil ? responseCache([FMNetworkCache httpCacheForURL:URL parameters:params]) : nil;
    
    @weakify(self)
    NSURLSessionTask *sessionTask = [self.client POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        @strongify(self)
        
        [self.arrayOfTasks removeObject:task];
        
        NSDictionary *responseObjectDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //对数据进行异步缓存
        responseCache!=nil ? [FMNetworkCache setHttpCache:responseObjectDictionary URL:URL parameters:params] : nil;
        
        if (success) {
            success(responseObjectDictionary);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        @strongify(self)
        
        [self.arrayOfTasks removeObject:task];
        
        if (failed) {
            failed(error.localizedDescription);
        }
        
    }];
    // 添加sessionTask到数组
    sessionTask ? [self.arrayOfTasks addObject:sessionTask] : nil ;
    
    return sessionTask;
    
}



- (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [self.arrayOfTasks enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [self.arrayOfTasks removeObject:task];
                *stop = YES;
            }
        }];
    }
}

- (void)cancelAllRequest
{
    //    [self.client.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 锁操作
    @synchronized(self) {
        [self.arrayOfTasks enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.arrayOfTasks removeAllObjects];
    }
}

- (void)downloadWithUrl:(NSString*)urlStr
                success:(void (^)(id data,NSString * message))success
                 failed:(void (^)(NSString* message))failed
               progress:(void (^)(CGFloat progress))progress {
    
    if ([urlStr isEmpty]) return;
    
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:newUrlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [self.client downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress.fractionCompleted);
        }
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            if (failed) {
                failed(error.localizedDescription);
            }
        } else {
            if (success)
            {
                success(filePath.absoluteString,@"下载完成");
            }
            
        }
    }];
    
    [downloadTask resume];
    
}

- (void)uploadImageWithUrl:(NSString*)urlStr
                    params:(NSDictionary *)params
                 thumbName:(NSString *)imagekey
                     image:(UIImage *)image
                   success:(void (^)(id data,NSString * message))success
                    failed:(void (^)(NSString* message))failed
                  progress:(void (^)(CGFloat progress))progress{
    
    if ([urlStr isEmpty]) return;
    
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData * data = UIImagePNGRepresentation(image);
    
    [self.client POST:newUrlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:imagekey fileName:@"01.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseObjectDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (success) {
            success(responseObjectDictionary,@"上传成功");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error.localizedDescription);
        }
    }];
}

- (void)uploadFileWithUrl:(NSString*)urlStr
                   params:(NSDictionary *)params
                 filePath:(NSString *)filePath
                     name:(NSString *)name
                  success:(void (^)(id data,NSString * message))success
                   failed:(void (^)(NSString* message))failed
                 progress:(void (^)(CGFloat progress))progress{
    
    if ([urlStr isEmpty]) return;
    
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self.client POST:newUrlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:[NSString stringWithFormat:@"%@.zip",name] mimeType:@"application/zip" error:NULL];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseObjectDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (success) {
            success(responseObjectDictionary,@"上传成功");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error.localizedDescription);
        }
    }];
}


@end
