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

@interface FMNetManager ()

@property(nonatomic , strong) AFHTTPSessionManager * httpManger;
@property(nonatomic , strong) AFURLSessionManager  * urlManager;
@end

@implementation FMNetManager

+ (instancetype)shareNetManager{
    static FMNetManager *_netManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netManager = [[FMNetManager alloc] init];
        _netManager.httpManger = [AFHTTPSessionManager manager];
        _netManager.httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/javascript",nil];
        _netManager.httpManger.requestSerializer.timeoutInterval = 10;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _netManager.urlManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    });
    return _netManager;
}

- (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters response:(void (^)(id))success{
    
    __weak typeof(self) weakSelf = self;
    //监测网络变化
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //检测网络连接的单例,网络变化时的回调方法
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status <= 0) {
//            [FMPromptTool promptModeText:@"没有网络了" afterDelay:2];
//        }else{
            MBProgressHUD *netPrompt = [FMPromptTool promptModeIndeterminatetext:@"正在加载中"];
            //加载数据

            [weakSelf.httpManger GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject) {
                    [netPrompt removeFromSuperview];
                    if (success) {
                        success(responseObject);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [netPrompt removeFromSuperview];
                NSLog(@"%@",error);
            }];
//        }
//    }];
}

- (void)netWorkToolDownloadWithUrl:(NSString *)string targetPath:(NSSearchPathDirectory)path DomainMask:(NSSearchPathDomainMask)mask endPath:(void(^)(NSURL *endPath))endPath{
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:string];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [self.urlManager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentUrl = [[NSFileManager defaultManager] URLForDirectory:path inDomain:mask appropriateForURL:nil create:NO error:nil];
      return  [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@",error);
        if (!error && endPath) {
            endPath(filePath);
        }
    }];
    [downloadTask resume];
}

@end
