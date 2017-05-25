//
//  FMNetManager.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMNetManager : NSObject

+ (instancetype)manager;

/**使用AFN进行get请求*/
- (void)getWithUrl:(NSString*)urlStr
            params:(NSDictionary *)params
           success:(void (^)(id data,NSString * message))success
            failed:(void (^)(NSString* message))failed;

/**使用AFN进行GET请求,自动缓存*/
- (__kindof NSURLSessionTask *)getWithUrl:(NSString *)URL
                                   params:(NSDictionary *)params
                            responseCache:(void (^)(id data))responseCache
                                  success:(void (^)(id data))success
                                   failed:(void (^)(NSString* message))failed;

/**使用AFN进行post请求*/
- (void)postWithUrl:(NSString*)urlStr
             params:(NSDictionary *)params
            success:(void (^)(id data,NSString * message))success
             failed:(void (^)(NSString* message))failed;


/**POST请求,自动缓存*/
- (__kindof NSURLSessionTask *)postWithUrl:(NSString *)URL
                                    params:(NSDictionary *)params
                             responseCache:(void (^)(id dat))responseCache
                                   success:(void (^)(id data))success
                                    failed:(void (^)(NSString* message))failed;

/**取消指定URL的HTTP请求*/
- (void)cancelRequestWithURL:(NSString *)URL;

/**取消所有网络请求*/
- (void)cancelAllRequest;


/**
 *  下载文件
 *
 *  @param urlStr   url路径
 *  @param success  下载成功
 *  @param failed  下载失败
 *  @param progress 下载进度
 */
- (void)downloadWithUrl:(NSString*)urlStr
                success:(void (^)(id data,NSString * message))success
                 failed:(void (^)(NSString* message))failed
               progress:(void (^)(CGFloat progress))progress;

/**
 *  上传图片
 *
 *  @param urlStr   url地址
 *  @param image    UIImage对象
 *  @param imagekey imagekey
 *  @param params   上传参数
 *  @param success  上传成功
 *  @param failed  上传失败
 *  @param progress 上传进度
 */
- (void)uploadImageWithUrl:(NSString*)urlStr
                    params:(NSDictionary *)params
                 thumbName:(NSString *)imagekey
                     image:(UIImage *)image
                   success:(void (^)(id data,NSString * message))success
                    failed:(void (^)(NSString* message))failed
                  progress:(void (^)(CGFloat progress))progress;


/**
 *  上传zip包
 *
 *  @param urlStr   url地址
 *  @param params   上传参数
 *  @param success  上传成功
 *  @param failed  上传失败
 *  @param progress 上传进度
 */
- (void)uploadFileWithUrl:(NSString*)urlStr
                   params:(NSDictionary *)params
                 filePath:(NSString *)filePath
                     name:(NSString *)name
                  success:(void (^)(id data,NSString * message))success
                   failed:(void (^)(NSString* message))failed
                 progress:(void (^)(CGFloat progress))progress;


@end

NS_ASSUME_NONNULL_END
