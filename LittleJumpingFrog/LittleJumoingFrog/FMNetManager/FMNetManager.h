//
//  FMNetManager.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMNetManager : NSObject

+ (instancetype)shareNetManager;

- (void)netWorkToolGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters response:(void(^)(id response))success;

- (void)netWorkToolDownloadWithUrl:(NSString *)string targetPath:(NSSearchPathDirectory)path DomainMask:(NSSearchPathDomainMask)mask endPath:(void(^)(NSURL *endPath))endPath;
@end
