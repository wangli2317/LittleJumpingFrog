//
//  DTSScrollViewManager.h
//  DTSPhone
//
//  Created by 王刚 on 2017/2/10.
//  Copyright © 2017年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMScrollView.h"
#import "FMScrollViewCell.h"

@protocol  FMScrollViewManagerDelegate;
@interface FMScrollViewManager : NSObject

@property (nonatomic, strong) FMScrollView *scrollView;

@property (nonatomic,assign) BOOL needRefresh;
@property (nonatomic,assign) BOOL showLoading;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) NSInteger lastUpDateTime;
@property (nonatomic,strong) NSMutableDictionary *otherParams;

@property (nonatomic, assign, readwrite) CGFloat adjustInsetHeight;

@property (nonatomic, weak) id <FMScrollViewManagerDelegate> vdelegate;


- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate;

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
             otherParams:(NSMutableDictionary *)otherParams;

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
                  startY:(CGFloat)startY
             otherParams:(NSMutableDictionary *)otherParams;

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
           numberColumns:(NSInteger)numberColumns
                  startY:(CGFloat)startY
             otherParams:(NSMutableDictionary *)otherParams;

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
             columnWidth:(CGFloat)columnWidth
                  startY:(CGFloat)startY
          leftMarginCols:(NSInteger)leftMarginCols
             otherParams:(NSMutableDictionary *)otherParams
    needPzRefreshControl:(BOOL)needPzRefreshControl;

- (id)initWithDataMethod:(NSString*)dataMethod
                   frame:(CGRect)frame
             andDelegate:(id <FMScrollViewManagerDelegate>)delegate
        defaultClassType:(NSString*)classType
             columnWidth:(CGFloat)columnWidth
                  startY:(CGFloat)startY
          leftMarginCols:(NSInteger)leftMarginCols
          cellPaddingTop:(CGFloat)cellPaddingTop
             otherParams:(NSMutableDictionary *)otherParams
    needPzRefreshControl:(BOOL)needPzRefreshControl;


- (void) startLoad;
- (void) startLoadWithFooterItems:(NSArray*) footerItems;
- (void) changeFooterItems:(NSArray *)footerItems;
- (void) reload;

- (void) reloadForRange:(NSRange)range;
- (void) clearDataInRange:(NSRange)range;
- (void) deleteDataAtIndex:(NSInteger)index;
- (void) changeDataSourceWithDataMethod:(NSString *)dataMethod otherParams:(NSMutableDictionary *)otherParams;
- (void) insertData:(id)data atIndex:(NSInteger)index;


@end

#pragma mark - Delegate

@protocol FMScrollViewManagerDelegate <NSObject>
- (void) beforeAddScrollView;
- (void) afterAddScrollView;
- (void) afterReloadScrollView;
- (UIView*) getParentView;

@optional
- (void) cellClicked:(FMScrollViewCell*)cell;
- (void) buttonClicked:(id)sender cell:(FMScrollViewCell *) cell;
- (void) reload;
- (void) afterLoadDataSource;
- (void) loadDataFaild;
- (void) moveCellAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
@end
