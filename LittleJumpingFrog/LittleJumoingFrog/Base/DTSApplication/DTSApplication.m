//
//  DTSApplication.m
//  DTSmogi
//
//  Created by 王刚 on 16/11/29.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "DTSApplication.h"

@interface DTSApplication ()<CoreStatusProtocol>

@end

@implementation DTSApplication

@dynamic currentStatus;

- (void)dealloc{
    [CoreStatus endNotiNetwork:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)application {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        
        [CoreStatus beginNotiNetwork:instance];
        
        [instance registerNotification];
        
        [instance setLang];
        
        [[UIButton appearance] setExclusiveTouch:YES];
        
    });
    
    return instance;
}

-(void)registerNotification{
    
    self.status = [CoreStatus currentNetWorkStatus];
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:DTSNOTIFI_RUNTIME_ERROR object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runtimeError:) name:DTSNOTIFI_RUNTIME_ERROR object:nil];
    
}

- (void)setLang{
    _lang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
}

- (NSString *)getBundleName
{
    NSString *bundleName =  [[FMDataManager manager] getValueForKey:@"bundleName" defvalue:@""];
    if ([bundleName isEqualToString:@""]) {
        return [[ NSBundle mainBundle] pathForResource: @"defaultImage" ofType :@"bundle"];
    }else{
        return[[ NSBundle mainBundle] pathForResource:bundleName ofType :@"bundle"];
    }
}

#pragma Network observering

-(void)coreNetworkChangeNoti:(NSNotification *)noti{
    
    self.status = [CoreStatus currentNetWorkStatus];
    [self invokeReachabilityChanged];

}

-(void)initAppSuccess:(void (^)(id data,NSString * message))success failed:(void (^)(NSString * message)) failed{
    
    self.status = [CoreStatus currentNetWorkStatus];
    
    //无网 不是第一次进入
//    if(self.status != CoreNetWorkStatusNone && [[NSUserDefaults standardUserDefaults] boolForKey:DTSFIRSTINIT_SUCCESS]){
//        
//        
//    }else if (self.status != CoreNetWorkStatusNone && ![[NSUserDefaults standardUserDefaults] boolForKey:DTSFIRSTINIT_SUCCESS]){
//        
//        //有网时做此动作 对比version
//        
//        //NSLog(@"****DTSAPPLication ***invokeReachability FAILED ");
//        
//    }
    
    if (self.status != CoreNetWorkStatusNone){
        
//        [[DTSDataManager manager]initAppWithDebugSuccess:^(id  _Nonnull data, NSString * _Nonnull message) {
//            if(success){
//                success(data,message);
//            }
//        } failed:^(NSString * _Nonnull message) {
//            NSLog(@"DTSAPPLication InitAPP Failed *** %@",message);
//            if (failed) {
//                failed(message);
//            }
//        }];

    }else{
        if (failed) {
            failed(@"false");
        }
    }
}

- (void) whetherFirstUse{

    //第一次使用app弹出提示,检查网络
//    if(self.status == CoreNetWorkStatusNone && ![[NSUserDefaults standardUserDefaults] boolForKey:DTSFIRSTINIT_SUCCESS]){
//
//    }else{
//        
//    }
}

#pragma alert confirm button
//alert click WIFI
-(void)comfirmBtnClicked{
    //跳转到设置wifi
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    
}

- (void)invokeReachabilityChanged{

//    [[NSNotificationCenter defaultCenter] postNotificationName:DTSNetWorkChangeNotification object:@(self.status)];
 
    switch (self.status) {
        case CoreNetWorkStatusNone:
            [GCDQueue executeInMainQueue:^{
                [MBProgressHUD showSuccess:@"当前无网络"];
            }];
            break;
        case CoreNetWorkStatusWifi:
        case CoreNetWorkStatusWWAN:
        case CoreNetWorkStatus2G:
        case CoreNetWorkStatus3G:
        case CoreNetWorkStatus4G:
        case CoreNetWorkStatusUnkhow:
            [GCDQueue executeInMainQueue:^{
                 [MBProgressHUD showSuccess:@"网络已连接"];
            }];
           
            break;

        default:
            break;
    }
    
}

- (void)switchRootController:(UIViewController *)viewController options:(UIViewAnimationOptions)options{
    
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    [UIView transitionWithView:[[UIApplication sharedApplication] keyWindow]
                      duration:0.3
                       options:options
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [[UIApplication sharedApplication] keyWindow].rootViewController = viewController;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:^(BOOL finished){
                        [vc dismissViewControllerAnimated:NO completion:^{
                            [vc.view removeAllSubviews];
                            vc.view = nil;
                        }];
                    }]; 
}

//全局弹窗
-(void)runtimeError:(NSNotification *)noti{

}

@end
