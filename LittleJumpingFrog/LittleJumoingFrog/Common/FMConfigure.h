//
//  FMConfigure.h
//  mogi
//
//  Created by 王刚 on 9/5/16.
//  Copyright © 2016年 王刚. All rights reserved.
//


#ifndef mogi_FMConfigure_h
#define mogi_FMConfigure_h


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

/*-----screenSize-----*/
#define Screen [[UIScreen mainScreen] bounds]
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBALPHA(rgbValue,alphaNum) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaNum]

//ios系统版本
#define ios9x [[[UIDevice currentDevice] systemVersion] floatValue] >=9.0f
#define ios8x [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)
#define ios7x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define ios6x [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f && ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
#define iosNot5x [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f
#define ios5x [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f


#define iphone4x_3_5 ([UIScreen mainScreen].bounds.size.height==480.0f)

#define iphone5x_4_0 ([UIScreen mainScreen].bounds.size.height==568.0f)

#define iphone6_4_7 ([UIScreen mainScreen].bounds.size.height==667.0f)

#define iphone6Plus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)

#define iphone6_4_7UP ([UIScreen mainScreen].bounds.size.height>=667.0f)

/*-----url-----*/

#define FMParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}

/*-----color-----*/
#define FColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define FMRandomColor FColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define FMMainColor FColor(252,12,68)
#define FMNumColor FColor(148,145,144)
#define FMTextColor FColor(45,46,47)
#define FMArtistColor FColor(110,111,112)
#define FMTintColor [FMMusicIndicator shareIndicator].tintColor

/*-----font-----*/
#define FMTitleFont [UIFont systemFontOfSize:20.0]
#define FMBigFont [UIFont systemFontOfSize:15.0]
#define FMMiddleFont [UIFont systemFontOfSize:13.0]
#define FMSmallFont [UIFont systemFontOfSize:10.0]
#endif
