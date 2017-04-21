//
//  FMSearchViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMSearchViewController.h"

@interface FMSearchViewController ()
@end

@implementation FMSearchViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self loadSearchData];
    }
    return self;
}

- (void)loadSearchData{
    
    __weak typeof(self) weakSelf  = self;
    
    [[FMDataManager manager]getHotSearchesSuccess:^(id data) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
         [strongSelf setValue:data forKey:@"hotSearches"];
        
    } failed:^(NSString *message) {
       [GCDQueue executeInMainQueue:^{
           [MBProgressHUD showError:message];
       }];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText{
    
    if (searchText.length) { // 与搜索条件再搜索
        // 根据条件发送查询（这里模拟搜索）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜素完毕
            // 显示建议搜索结果
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // 返回
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

@end
