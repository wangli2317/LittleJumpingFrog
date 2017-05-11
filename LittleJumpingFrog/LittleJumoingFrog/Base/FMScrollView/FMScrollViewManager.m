//
//  FMScrollViewManager.m
//  DTSPhone
//
//  Created by 王刚 on 2017/2/10.
//  Copyright © 2017年 DTS. All rights reserved.
//

#import "FMScrollViewManager.h"
#import "FMDataManager.h"
#import "NSDate+Utils.h"

@interface FMScrollViewManager () <FMScrollViewDelegate, FMScrollViewDataSource>

@property (nonatomic, assign, readwrite) NSUInteger page;
@property (nonatomic, assign, readwrite) NSUInteger cellMarginLeftCols;

@property (nonatomic, assign, readwrite) NSString* dataMethod;

@property (nonatomic,assign)BOOL needPzRefreshControl;

@property (nonatomic, assign) NSUInteger totalPage;
@end

@implementation FMScrollViewManager

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate{
    
    return [self initWithDataMethod:dataMethod
                              frame:frame
                        andDelegate:delegate
                   defaultClassType:@"FMScrollViewCell"
                        otherParams:nil];
    
}

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
             otherParams:(NSMutableDictionary *)otherParams{
    
    return [self initWithDataMethod:dataMethod
                              frame:frame
                        andDelegate:delegate
                   defaultClassType:@"FMScrollViewCell"
                        otherParams:otherParams];
    
}
- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
             otherParams:(NSMutableDictionary *)otherParams{
    
    return [self initWithDataMethod:dataMethod
                              frame:frame
                        andDelegate:delegate
                   defaultClassType:classType
                      numberColumns:10
                             startY:0.0f
                        otherParams:otherParams];
    
}


- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
                  startY:(CGFloat)startY
             otherParams:(NSMutableDictionary *)otherParams{
    
    return [self initWithDataMethod:dataMethod
                              frame:frame
                        andDelegate:delegate
                   defaultClassType:classType
                      numberColumns:10
                             startY:startY
                        otherParams:otherParams];
}

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
           numberColumns:(NSInteger)numberColumns
                  startY:(CGFloat)startY
             otherParams:(NSMutableDictionary *)otherParams {
    
    CGFloat columnWidth = frame.size.width/numberColumns;
    
    return [self initWithDataMethod:dataMethod
                              frame:frame
                        andDelegate:delegate
                   defaultClassType:classType
                        columnWidth:columnWidth
                             startY:startY
                     leftMarginCols:1
                        otherParams:otherParams
               needPzRefreshControl:NO];
    
}

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
             columnWidth:(CGFloat)columnWidth
                  startY:(CGFloat)startY
          leftMarginCols:(NSInteger)leftMarginCols
             otherParams:(NSMutableDictionary *)otherParams
    needPzRefreshControl:(BOOL)needPzRefreshControl{
    
    return [self initWithDataMethod:dataMethod
                              frame:frame
                        andDelegate:delegate
                   defaultClassType:classType
                        columnWidth:columnWidth
                             startY:startY
                     leftMarginCols:leftMarginCols
                     cellPaddingTop:0
                        otherParams:otherParams
               needPzRefreshControl:needPzRefreshControl];
}

- (id)initWithDataMethod:(NSString*)dataMethod frame:(CGRect)frame andDelegate:(id <FMScrollViewManagerDelegate>)delegate defaultClassType:(NSString*)classType columnWidth:(CGFloat)columnWidth startY:(CGFloat)startY leftMarginCols:(NSInteger)leftMarginCols cellPaddingTop:(CGFloat)cellPaddingTop otherParams:(NSMutableDictionary *)otherParams needPzRefreshControl:(BOOL)needPzRefreshControl{
    self = [super init];
    if (!self)
        return nil;
    self.page=1;
    self.dataMethod = dataMethod;
    self.needRefresh = NO;
    self.showLoading = NO;
    self.isLoading = NO;
    self.vdelegate = delegate;
    self.lastUpDateTime = 0;
    self.otherParams = otherParams;
    
    self.scrollView  = [[FMScrollView alloc] initWithProperties:frame columWidth:columnWidth cellPaddingTop:cellPaddingTop startY:startY cellMarginLeftCols:leftMarginCols needPzRefreshControl:needPzRefreshControl];
    self.scrollView.vdelegate = self;
    self.scrollView.vdataSource = self;
    self.scrollView.defaultClassType = (classType==nil)?@"FMScrollViewCell":classType;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.needPzRefreshControl = needPzRefreshControl;
    
    return self;
}


- (void)startLoad{
    [self startLoadWithFooterItems:nil];
}

- (void)startLoadWithFooterItems:(NSArray *)footerItems{
    
    if(footerItems!=nil){
        [self.scrollView fillFooterItems:footerItems];
    }
    [self.vdelegate beforeAddScrollView];
    [[self.vdelegate getParentView] addSubview:self.scrollView];
    [self.vdelegate afterAddScrollView];
    
    
    [self loadDataSource];
    
    self.isLoading = YES;
}

- (void)changeFooterItems:(NSArray *)footerItems{
    
    if(footerItems!=nil){
        [self.scrollView fillFooterItems:footerItems];
    }
    
}

- (void)loadDataSource {
    
    
    if(self.dataMethod!=nil){
        
        if (self.totalPage && self.page > self.totalPage) {
            return;
        }
        
        if(self.page==1 && self.needPzRefreshControl){
            [self.scrollView beginLoading];
            if(self.showLoading){
                //TODO: add loading view
            }
        }
        
        @weakify(self)
        [[FMDataManager manager] fetchDataFromServerWithDataMethod:self.dataMethod page:self.page otherParams:self.otherParams success:^(id data, NSInteger totalPage) {
            @strongify(self)
            
            self.totalPage = totalPage;
            
            if(self.scrollView.reloading || self.needRefresh){
                self.needRefresh = NO;
                //[self.scrollView doneReloadingTableViewData];
                [self.scrollView clearDataForNew];
                [self.vdelegate afterReloadScrollView];
            }
            
            
            NSUInteger count = [data count];
            if(count==0){
                if(self.page==1){
                    if(self.showLoading){
                        //TODO: add No Data view
                    }
                }
                if ([self.vdelegate respondsToSelector:@selector(afterLoadDataSource)]) {
                    [self.vdelegate afterLoadDataSource];
                }
            }else{
                NSMutableArray *rss = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i<[data count]; i++) {
                    [rss addObject:[data objectAtIndex:i]];
                }
                [self.scrollView append:rss];
                if (self.page == 1) {
                    self.lastUpDateTime = [NSDate getTimeSp];
                }
                [self.otherParams setValue:@(self.lastUpDateTime) forKey:@"lastUpDateTime"];
                
            }
            self.isLoading = NO;
            
            [self.scrollView finishLoading];
            [self adjustScrollInset];
            
        } failed:^(NSString *message) {
            
            @strongify(self)
            NSLog(@"Faild!");
            if ([self.vdelegate respondsToSelector:@selector(loadDataFaild)]) {
                [self.vdelegate loadDataFaild];
            }
            if(self.page==1&&[self.scrollView itemsCount]==0){
                if(self.showLoading){
                    //TODO: add Load Data Error
                }
            }
            //self.isLoading = NO;
            [self.scrollView finishLoading];
            [self.scrollView doneReloadingTableViewData];
            [self loadMoreCompleted];
        }];
        
    }else{
        [self.scrollView finishLoading];
        [self.scrollView doneReloadingTableViewData];
        [self loadMoreCompleted];
        
    }
}


-(void)reload{
    self.page=1;
    if(self.needRefresh){
        //        self.needRefresh = NO;
        self.lastUpDateTime = 0;
        //        [self.scrollView clearDataForNew];
        //        [self.vdelegate afterReloadScrollView];
    }
    if(![[[self.vdelegate getParentView] subviews] containsObject:self.scrollView]){
        [[self.vdelegate getParentView] addSubview:self.scrollView];
    }
    [self loadDataSource];
    self.isLoading = YES;
}

- (void) clearDataInRange:(NSRange)range{
    [self.scrollView clearDataInRange:range];
}   

- (void) deleteDataAtIndex:(NSInteger)index{
    [self clearDataInRange:NSMakeRange(index, 1)];
}

-(void)reloadForRange:(NSRange)range{
    self.page=1;
    self.lastUpDateTime = 0;
    if(self.needRefresh){
        self.needRefresh = NO;
        [self.scrollView clearDataInRange:range];
    }
    [self loadDataSource];
    self.isLoading = YES;
}

- (void) changeDataSourceWithDataMethod:(NSString *)dataMethod otherParams:(NSMutableDictionary *)otherParams{
    self.dataMethod = dataMethod;
    self.otherParams = otherParams;
    ////    self.scrollView.reloading = YES;
    //    self.page = 1;
    //    [self reload];
    self.needRefresh = YES;
    [self reload];
    
}

-(void)adjustScrollInset{
    if(self && self.vdelegate && [self.vdelegate isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController*) self.vdelegate;
        vc.automaticallyAdjustsScrollViewInsets = YES;
        if(vc.tabBarController){
            self.adjustInsetHeight = CGRectGetHeight(vc.tabBarController.tabBar.frame);
        }
    }
    
    if(self.adjustInsetHeight>0){
        UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, self.adjustInsetHeight, 0);
        self.scrollView.contentInset = adjustForTabbarInsets;
        self.scrollView.scrollIndicatorInsets = adjustForTabbarInsets;
    }
    
}


#pragma mark - Delegate

- (void) loadMoreCompleted{
    self.isLoading = NO;
    //NOTE: if you add loaing indicator, plese stop or hide it here
}
- (void) willBeginLoadingMore{
    
}

- (void) didSelectView:(FMScrollViewCell *) cell{
    NSLog(@"didSelectView in waterfallmanager");
    NSString* cls = NSStringFromClass([cell class]);
    
    //add some common view cell click method
    if([cls isEqualToString:@"PZWaterfallTxtCell"]||[cls isEqualToString:@"PZWaterfallCell"]){
        
    }else{
        if (self.vdelegate && [self.vdelegate respondsToSelector:@selector(cellClicked:)]) {
            [self.vdelegate cellClicked:cell];
        }
    }
    
}


-(void) buttonClicked:(id)sender cell:(FMScrollViewCell *) cell{
    NSString* cls = NSStringFromClass([cell class]);
    
    if([cls isEqualToString:@"PZWaterfallTxtCell"]){
        
    }else{
        if (self.vdelegate && [self.vdelegate respondsToSelector:@selector(buttonClicked:cell:)]) {
            [self.vdelegate buttonClicked:sender cell:cell];
        }
    }
}

- (void)moveItemAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex{
    
    if (self.vdelegate && [self.vdelegate respondsToSelector:@selector(moveCellAtIndex:toIndex:)]) {
        [self.vdelegate moveCellAtIndex:index toIndex:newIndex];
    }
    
}

#pragma mark - DataSource
- (void) pullRefresh{
    //self.needRefresh = TRUE;
    self.page=1;
    //[self.collectionView clearDataForNew];
    if (self.vdelegate && [self.vdelegate respondsToSelector:@selector(reload)]) {
        [self.vdelegate reload];
    }else{
        [self reload];
    }
}
- (void) getMoreBricks{
    self.page++;
    [self loadDataSource];
}


- (void) insertData:(id)data atIndex:(NSInteger)index{
    
    [self.scrollView.items insertObject:data atIndex:index];
    [self.scrollView afterInsertAtIndex:index];
    
}

@end
