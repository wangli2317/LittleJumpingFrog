//
//  FMNetManager.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMNetManager.h"
#import <AFNetworking.h>
#import "FMConfigure.h"
#import "NSObject+Utils.h"
#import "DTSApplication.h"

//超时时间
NSInteger const retry = 10;

@interface FMNetManager ()

@property(nonatomic , strong) AFHTTPSessionManager * client;
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

- (void)postWithUrl:(NSString *)urlStr
               body:(NSDictionary *)body
            success:(void (^)(id _Nonnull, NSString * _Nonnull))success
             failed:(void (^)(NSString * _Nonnull))failed
{
    if ([urlStr isEmpty]) return;
    
    [FMNetManager manager].client.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if([DTSApplication application].status == CoreNetWorkStatusNone){
        if (failed) {
            failed(@"当前无网络, 请检查您的网络状态");
        }
    }else
    {
        NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.client POST:newUrlStr parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void)cancelAllRequest{
    [self.client.operationQueue cancelAllOperations];
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
