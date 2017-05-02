//
//  FMScrollView.m
//  DTSPhone
//
//  Created by 王刚 on 2017/2/10.
//  Copyright © 2017年 DTS. All rights reserved.
//

#import "FMScrollView.h"
#import "FMScrollViewCell.h"
#import "NSObject+Utils.h"
#import "PZPathAnimCircleRefreshControl.h"
#import "PZRefreshControlDefaultStyle.h"
#import "PZRefreshNormalControl.h"

#define DEFAULT_PADDING 10.0
#define DEFAULT_COLWIDTH 10.0
#define DEFAULT_HEIGHT_OFFSET 300.0f

static inline NSString * Index2String(NSInteger index) {
    return [NSString stringWithFormat:@"%ld", (long)index];
}

static inline NSInteger String2Index(NSString *key) {
    return [key integerValue];
}


// This is just so we know that we sent this tap gesture recognizer in the delegate
@interface FMScrollViewTapGestureRecognizer : UITapGestureRecognizer
@end

@implementation FMScrollViewTapGestureRecognizer
@end

@interface FMScrollViewPanGestureRecognizer : UIPanGestureRecognizer
@end

@implementation FMScrollViewPanGestureRecognizer
@end

@interface FMScrollViewLongPressGestureRecognizer : UILongPressGestureRecognizer
@end

@implementation FMScrollViewLongPressGestureRecognizer
@end

@interface FMScrollView () <UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) CGFloat offsetThreshold;
@property (nonatomic, assign, readwrite) CGFloat lastStopScrollY;
@property (nonatomic, assign, readwrite) CGFloat lastOffset;
@property (nonatomic, assign, readwrite) CGFloat startY;


@property (nonatomic, assign, readwrite) NSString* currentFixedIndexTmp;
@property (nonatomic, strong) FMScrollViewCell* currentFixedCellTmp;


@property (strong, nonatomic) PZRefreshNormalControl* pzRefreshControl;

@property (readonly) BOOL isDragging;
@property (readonly) BOOL isRefreshing;
@property (readonly) BOOL isLoadingMore;
@property (readonly) BOOL canLoadMore;
@property (readonly) BOOL isLayouting;

@property (nonatomic, assign, readwrite) CGPoint previousOffset;


@property (nonatomic, strong) NSMutableArray *colYs;
@property (nonatomic, strong) NSMutableArray *viewKeysToRemove;
@property (nonatomic, strong) NSMutableDictionary *reuseableViews;
@property (nonatomic, strong) NSMutableDictionary *visibleViews;
@property (nonatomic, strong) NSMutableDictionary *indexToFrameMap;
@property (nonatomic, strong) NSMutableDictionary *indexTofixedCellFrameMap;
@property (nonatomic, strong) NSMutableDictionary *indexToExpandMap;

@property (nonatomic, assign) NSInteger longPressProcessing;
@property (nonatomic, assign) NSInteger panProcessing;

@end

@implementation FMScrollView

@synthesize isLayouting;
@synthesize isDragging;
@synthesize isRefreshing;
@synthesize isLoadingMore;
@synthesize previousOffset;
@synthesize bufferViewFactor;
@synthesize reloading;
@synthesize canLoadMore;

#pragma mark - Initializers

- (id) initWithProperties:(CGRect)frame{
    self = [self initWithProperties:frame columWidth:DEFAULT_COLWIDTH cellPaddingTop:DEFAULT_PADDING];
    return self;
}

- (id) initWithProperties:(CGRect)frame
               columWidth:(CGFloat)columWidth
           cellPaddingTop:(CGFloat)cellPaddingTop{
    self = [self initWithProperties:frame columWidth:columWidth cellPaddingTop:cellPaddingTop startY:0 cellMarginLeftCols:1 needPzRefreshControl:NO];
    return self;
}


- (id) initWithProperties:(CGRect)frame
               columWidth:(CGFloat)columWidth
           cellPaddingTop:(CGFloat)cellPaddingTop
                   startY:(CGFloat)startY
       cellMarginLeftCols:(NSInteger)cellMarginLeftCols
     needPzRefreshControl:(BOOL)needPzRefreshControl{
    
    self = [super initWithFrame:frame];
    
    if(!self) return nil;
    [self setDelaysContentTouches:NO];
    self.canCancelContentTouches = YES;
    self.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = YES;
    self.showsVerticalScrollIndicator = YES;
    self.delegate = self;
    self.exclusiveTouch = NO;
    isLayouting = NO;
    canLoadMore = YES;
    reloading = NO;
    isLoadingMore = NO;
    
    self.startY = startY;
    self.columnWidth = columWidth;
    self.cellMarginLeftCols = cellMarginLeftCols;
    self.cellMarginLeft = cellMarginLeftCols * columWidth;
    self.cellPaddingTop = cellPaddingTop;
    self.offsetThreshold = floorf(self.height);
    self.lastStopScrollY = 0;
    
    self.reuseableViews = [NSMutableDictionary dictionary];
    self.visibleViews = [NSMutableDictionary dictionary];
    self.viewKeysToRemove = [NSMutableArray array];
    self.items = [NSMutableArray array];
    self.footerItems = [NSMutableArray array];
    self.indexToFrameMap = [NSMutableDictionary dictionary];
    self.indexTofixedCellFrameMap = [NSMutableDictionary dictionary];
    self.indexToExpandMap = [NSMutableDictionary dictionary];
    self.previousOffset = CGPointMake(0, 0);
    self.bufferViewFactor = 2;
    self.longPressProcessing = 0;
    self.panProcessing = 0;
    [self initColums];
    
    if (needPzRefreshControl) {
        
        [self addRefreshControl];
    }
    
    return self;
}

- (void) initColums{
    self.numCols = self.width/(self.columnWidth);
    self.numCols = MAX(self.numCols, 1);
    self.colYs = nil;
    self.colYs = [[NSMutableArray alloc] init];
    
    NSInteger i = self.numCols;
    while (i--) {
        [self.colYs addObject:[NSNumber numberWithFloat:self.cellPaddingTop+self.startY]];
    }
}


#pragma mark - Data Manage

- (void) append:(NSMutableArray *)items{
    NSLog(@"%td",self.items.count);
    NSInteger numFooterItems = [self.footerItems count];
    NSInteger numBeforeAdd = [self.items count];
    
    if(numFooterItems>0){
        numBeforeAdd = MAX(0, numBeforeAdd-numFooterItems);
        if(numBeforeAdd>0){
            [self clearDataInRange:NSMakeRange(numBeforeAdd, numFooterItems)];
        }
    }
    [self.items addObjectsFromArray:items];
    if(numFooterItems>0){
        [self.items addObjectsFromArray:self.footerItems];
    }
    NSUInteger numAfterAdd = [self.items count];
    for (NSUInteger i = numBeforeAdd; i<numAfterAdd; i++) {
        [self placeFrame:[self.items objectAtIndex:i] index:i];
    }
    
    NSNumber *maxY = [self.colYs objectAtIndex:0];
    for (NSInteger i = 0; i<[self.colYs count]; i++) {
        NSNumber *g = (NSNumber *)[self.colYs objectAtIndex:i];
        maxY = (g.floatValue>maxY.floatValue)?g:maxY;
    }
    
    CGSize newSize = CGSizeMake(self.width, maxY.floatValue);
    [self setContentSize:newSize];
    
    [self layoutdata];
}

- (void) placeFrame:(id)item index:(NSUInteger)index {
    NSMutableArray *groupY;
    NSUInteger groupCount;
    CGFloat expandWidth = 0;
    CGFloat expandHeight = 0;
    
    NSString *expandSizeString = [self.indexToExpandMap objectForKey:Index2String(index)];
    
    if(expandSizeString!=nil){
        CGSize expandSize = CGSizeFromString(expandSizeString);
        expandWidth = expandSize.width;
        expandHeight = expandSize.height;
    }
    
    Class cls = [self classForCellOfObject:item];
    
    NSUInteger bwidth = [self getBrickWidthFromClass:cls andObject:item]+expandWidth;
    NSUInteger bheight = [self getBrickHeightFromClass:cls andObject:item]+expandHeight;
    CGFloat bheightOffset = [self getBrickHeightOffsetFromClass:cls andObject:item];
    CGFloat xOffset = [self getBrickXOffsetFromClass:cls andObject:item];
    
    //NSUInteger colspan = ceilf(bwidth/(self.columnWidth+xOffset))+self.cellMarginLeftCols;
    NSUInteger colspan = floorf(bwidth/(self.columnWidth+xOffset))+self.cellMarginLeftCols;
    colspan = MIN(colspan, self.numCols);
    
    if ( colspan == 1 ) {
        // if brick spans only one column, just like singleMode
        groupY = self.colYs;
    } else {
        // brick spans more than one column
        // how many different places could this brick fit horizontally
        groupCount = self.numCols + 1 - colspan;
        groupY = [[NSMutableArray alloc] init];
        
        // for each group potential horizontal position
        for ( NSUInteger j=0; j < groupCount; j++ ) {
            // make an array of colY values for that one group
            NSNumber *maxcol = [NSNumber numberWithInt:0];
            for (NSUInteger k=j; k<j+colspan; k++) {
                NSNumber *c = (NSNumber *)[self.colYs objectAtIndex:k];
                maxcol = (c.intValue>maxcol.intValue)?c:maxcol;
            }
            
            [groupY addObject:maxcol];
        }
        
    }
    
    
    NSNumber *minimumY = [groupY objectAtIndex:0];
    for (NSInteger i = 0; i<[groupY count]; i++) {
        NSNumber *g = (NSNumber *)[groupY objectAtIndex:i];
        minimumY = (g.floatValue<minimumY.floatValue)?g:minimumY;
    }
    
    NSUInteger shortCol = [groupY indexOfObject:minimumY];
    
    CGRect frame = CGRectZero;
    
    if(shortCol==0){
        frame = CGRectMake(self.cellMarginLeft+xOffset, (minimumY.floatValue+bheightOffset), bwidth+expandWidth, bheight+expandHeight);
    }else{
        
        frame = CGRectMake((self.columnWidth*shortCol+self.cellMarginLeft+xOffset), (minimumY.floatValue+bheightOffset), bwidth+expandWidth, bheight+expandHeight);
    }
    
    [self.indexToFrameMap setObject:NSStringFromCGRect(frame) forKey:Index2String(index)];
    if ([cls fixedCell]) {
        [self.indexTofixedCellFrameMap setObject:NSStringFromCGRect(frame) forKey:Index2String(index)];
    }
    
    // apply setHeight to necessary columns
    GLfloat setHeight = minimumY.floatValue + bheight + expandHeight +self.cellPaddingTop+bheightOffset;
    NSUInteger setSpan = self.numCols + 1 - [groupY count];
    for (NSUInteger i=0; i < setSpan; i++ ) {
        [self.colYs replaceObjectAtIndex:shortCol+i withObject:[NSNumber numberWithFloat:setHeight]];
    }
    
}

- (void) fillFooterItems:(NSArray *)footerItems{
    if([self.footerItems count]>0){
        [self.footerItems removeAllObjects];
    }
    [self.footerItems addObjectsFromArray:footerItems];
}

- (void) reCalculateFrameFromIndex:(NSInteger)index expandWidth:(CGFloat)expandWidth expandHeight:(CGFloat)expandHeight{
    
    
    NSMutableArray *groupY = [[NSMutableArray alloc] init];
    
    BOOL findStart0 = NO;
    
    for (NSInteger k = index; k>=0; k--) {
        NSString *key = Index2String(k);
        CGRect rect = CGRectFromString([self.indexToFrameMap objectForKey:key]);
        //CGRect rectBefore = CGRectFromString([self.indexToFrameMap objectForKey:Index2String(k-1)]);
        
        
//        FMBaseDTO * item = [self.items objectAtIndex:k];
//        Class cls = [self classForCellOfObject:item];
        
        NSDictionary *item = [self.items objectAtIndex:k];
        Class cls = [self classForCellOfObject:item];
        
        //CGFloat xOffset = [self getBrickXOffsetFromClass:cls andObject:item];
        CGFloat bheightOffset = [self getBrickHeightOffsetFromClass:cls andObject:item];
        
        NSUInteger startColumnNum= (rect.origin.x/self.columnWidth)-self.cellMarginLeftCols;
        NSUInteger endColumnNum = ceil(((rect.origin.x+rect.size.width)/self.columnWidth));
        startColumnNum = MAX(0, startColumnNum);
        endColumnNum = MIN(self.numCols, endColumnNum);
        
        for (NSUInteger i=startColumnNum; i < endColumnNum; i++ ) {
            if(![groupY containsObject:[NSNumber numberWithInteger:i]]){
                [groupY addObject:[NSNumber numberWithInteger:i]];
                
                
                if(k == index){
                    [self.colYs replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:rect.origin.y-bheightOffset]];
                }else{
                    [self.colYs replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:(rect.origin.y+rect.size.height+bheightOffset+self.cellPaddingTop)]];
                }
                
            }
        }
        if(findStart0&&startColumnNum==0){
            break;
        }
        
        if(startColumnNum==0){
            findStart0 = YES;
        }
        
    }
    
    for (NSInteger j = index; j<[self.items count]; j++) {
        NSObject* item = [self.items objectAtIndex:j];
        if(j == index){
            [self.indexToExpandMap setObject:NSStringFromCGSize(CGSizeMake(expandWidth, expandHeight)) forKey:Index2String(index)];
        }
        [self placeFrame:item index:j];
    }
    
    
    NSNumber *maxY = [self.colYs objectAtIndex:0];
    for (NSInteger i = 0; i<[self.colYs count]; i++) {
        NSNumber *g = (NSNumber *)[self.colYs objectAtIndex:i];
        maxY = (g.floatValue>maxY.floatValue)?g:maxY;
    }
    
    CGSize newSize = CGSizeMake(self.width, maxY.floatValue);
    [self setContentSize:newSize];
    
}


-(void)relayoutdata{
    [self initColums];
    
    canLoadMore = YES;
    self.offsetThreshold = floorf(self.height);
    
    // Reset all state
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        FMScrollViewCell *view = (FMScrollViewCell *)obj;
        [self enqueueReusableView:view];
    }];
    
    [self.visibleViews removeAllObjects];
    [self.viewKeysToRemove removeAllObjects];
    [self.indexToFrameMap removeAllObjects];
    [self.indexToExpandMap removeAllObjects];
    [self.indexTofixedCellFrameMap removeAllObjects];
    self.currentFixedIndexTmp = nil;
    self.currentFixedCellTmp = nil;
    self.previousOffset = CGPointMake(0, 0);
    
    NSUInteger numBeforeAdd = [self.items count];
    for (NSUInteger i = 0; i<numBeforeAdd; i++) {
        [self placeFrame:[self.items objectAtIndex:i] index:i];
    }
    
    NSNumber *maxY = [self.colYs objectAtIndex:0];
    for (NSInteger i = 0; i<[self.colYs count]; i++) {
        NSNumber *g = (NSNumber *)[self.colYs objectAtIndex:i];
        maxY = (g.floatValue>maxY.floatValue)?g:maxY;
    }
    
    CGSize newSize = CGSizeMake(self.width, maxY.floatValue);
    [self setContentSize:newSize];
    
    [self layoutdata];
    
}

- (void) layoutdata{
    NSInteger numViews = [self.items count];
    [self layoutBricks:numViews];
    [self loadMoreCompleted];
}

-(void)layoutWithStartY:(CGFloat)startY{
    self.startY = startY;
    [self relayoutdata];
}

- (void) layoutBricks:(NSInteger)numViews {
    isLayouting = YES;
    static NSInteger topIndex = 0;
    static NSInteger bottomIndex = 0;
    
    // Find out what rows are visible
    CGRect realVisibleRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.width, self.height);
    CGRect visibleRect = CGRectInset(realVisibleRect, 0, -1.0 * self.offsetThreshold);
    
    // Remove all rows that are not inside the visible rect
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        FMScrollViewCell *view = (FMScrollViewCell *)obj;
        CGRect viewRect = view.frame;
        if (!CGRectIntersectsRect(visibleRect, viewRect)) {
            [self enqueueReusableView:view];
            [self.viewKeysToRemove addObject:key];
        }
    }];
    
    [self.visibleViews removeObjectsForKeys:self.viewKeysToRemove];
    [self.viewKeysToRemove removeAllObjects];
    
    if ([self.visibleViews count] == 0) {
        topIndex = 0;
        bottomIndex = numViews;
    } else {
        NSArray *sortedKeys = [[self.visibleViews allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
        topIndex = [[sortedKeys objectAtIndex:0] integerValue];
        bottomIndex = [[sortedKeys lastObject] integerValue];
        topIndex = topIndex - (bufferViewFactor * self.numCols);
        topIndex = (topIndex>0)?topIndex:0;
        bottomIndex = MIN(numViews, bottomIndex + (bufferViewFactor * self.numCols));
    }
    //    NSLog(@"topIndex: %d, bottomIndex: %d", topIndex, bottomIndex);
    
    // Add views
    for (NSInteger i = topIndex; i < bottomIndex; i++) {
        NSString *key = Index2String(i);
        CGRect rect = CGRectFromString([self.indexToFrameMap objectForKey:key]);
        
        // If view is within visible rect and is not already shown
        if (![self.visibleViews objectForKey:key] && CGRectIntersectsRect(visibleRect, rect)) {
            // Only add views if not visible
            
            FMScrollViewCell *newCell = [self fillBrickView:[self.items objectAtIndex:i] atIndex:i frame:rect];
            newCell.frame = rect;
            [self addSubview:newCell];
            
            [self.visibleViews setObject:newCell forKey:key];
        }
        
        if(CGRectIntersectsRect(visibleRect, rect)){
            FMScrollViewCell *vcell = [self.visibleViews objectForKey:key];
            [vcell cellAppear];
            // Setup gesture recognizer
            
            if ([vcell.gestureRecognizers count] == 0) {
                FMScrollViewTapGestureRecognizer *gr = [[FMScrollViewTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectView:)];
                gr.delegate = self;
                gr.cancelsTouchesInView = NO;
                //gr.delaysTouchesBegan = YES;
                [vcell addGestureRecognizer:gr];
                
                if (vcell.canBeLongPress) {
                    FMScrollViewLongPressGestureRecognizer * lgr = [[FMScrollViewLongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressView:)];
                    lgr.delegate = self;
                    [vcell addGestureRecognizer:lgr];
                }
                
                //                FMScrollViewPanGestureRecognizer *gpr = [[FMScrollViewPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanView:)];
                //                gpr.delegate = self;
                //                //[gpr requireGestureRecognizerToFail:self.panGestureRecognizer];
                //                //gpr.cancelsTouchesInView = YES;
                //                [self addGestureRecognizer:gpr];
                
                if (vcell.canBeMovedToLeft) {
                    
                    FMScrollViewPanGestureRecognizer *gpr = [[FMScrollViewPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanView:)];
                    gpr.delegate = self;
                    //                    [self.panGestureRecognizer requireGestureRecognizerToFail:gpr];
                    //[gpr requireGestureRecognizerToFail:self.panGestureRecognizer];
                    //gpr.cancelsTouchesInView = YES;
                    [vcell addGestureRecognizer:gpr];
                    
                }
                
                
                vcell.userInteractionEnabled = YES;
                //NSLog(@"add gestureRecognizer to cell");
            }
            
        }
    }
    isLayouting = NO;
}


- (void)resizeFrameAtIndex:(NSUInteger)index expandWidth:(CGFloat)expandWidth expandHeight:(CGFloat)expandHeight{
    
    [self reCalculateFrameFromIndex:index expandWidth:expandWidth expandHeight:expandHeight];
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        FMScrollViewCell *view = (FMScrollViewCell *)obj;
        if(![self.currentFixedIndexTmp isEqualToString:key]){
            view.frame = CGRectFromString([self.indexToFrameMap objectForKey:key]);
        }
        if(view.index == index && expandHeight!=0){
            [view cellRefreshAppearWithObject:[self.items objectAtIndex:index]];
        }
        if(view.index == index && view.canBeMovedToLeftWidth){
            CGRect orgFrame = CGRectFromString([self.indexToFrameMap objectForKey:Index2String(view.index)]);
            [view movedToLeftViewWithOffsetX:0 orgFrame:orgFrame];
        }
    }];
}


- (void)changeItemDataAtIndex:(NSUInteger)index object:(id)object{
    if (!object) return;
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        FMScrollViewCell *cell = (FMScrollViewCell *)obj;
        if (cell.index == index) {
            [self.items removeObjectAtIndex:index];
            [self.items insertObject:object atIndex:index];
            [cell cellRefreshAppearWithObject:object];
        }
    }];
}


- (void)afterInsertAtIndex:(NSUInteger)index{
    
    [self reCalculateFrameFromIndex:index expandWidth:0 expandHeight:0];
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        FMScrollViewCell *view = (FMScrollViewCell *)obj;
        if(![self.currentFixedIndexTmp isEqualToString:key]){
            view.frame = CGRectFromString([self.indexToFrameMap objectForKey:key]);
        }
        if(view.index >= index){
            [view cellRefreshAppearWithObject:[self.items objectAtIndex:view.index]];
        }
        if(view.index == index && view.canBeMovedToLeftWidth){
            CGRect orgFrame = CGRectFromString([self.indexToFrameMap objectForKey:Index2String(view.index)]);
            [view movedToLeftViewWithOffsetX:0 orgFrame:orgFrame];
        }
    }];
    [self layoutdata];
}




- (void)addRefreshControl{
    
    if(!self.pzRefreshControl){
        self.pzRefreshControl = [PZRefreshNormalControl attachToScrollView:self withRefreshTarget:self andRefreshAction:@selector(refreshTriggered) styleClass:[PZRefreshControlDefaultStyle class]];
    }
    
    //    self.pzRefreshControl = [PZRefreshControl attachToScrollView:self
    //                                               withRefreshTarget:self
    //                                                andRefreshAction:@selector(refreshTriggered)];
    //    self.pzRefreshControl.backgroundColor = [UIColor clearColor];
    //    self.pzRefreshControl.foregroundColor = [UIColor colorWithRed:1.000f green:0.796f blue:0.020f alpha:1.0f];
    //    if(!self.pzRefreshControl){
    //        self.pzRefreshControl = [[PZPathAnimCircleRefreshControl alloc] initWithRefreshTarget:self andRefreshAction:@selector(refreshControlDidRefresh) styleClass:[PZRefreshControlDefaultStyle class]];
            [self addSubview:self.pzRefreshControl];
    //    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger numViews = [self.items count];
    
    if(numViews>0){
        CGFloat diff = fabs(self.lastOffset - self.contentOffset.y);
        
        if (diff > 100&&!isLayouting) {
            //if ((diff > 50&&!isLayouting) || (diff==0&&vnums==0)) {
            self.lastOffset = self.contentOffset.y;
            [self layoutBricks:numViews];
        }
    }
}


- (void) loadMore {
    if (isLoadingMore) return;
    
    isLoadingMore = YES;
    [self.vdelegate willBeginLoadingMore];
    [self.vdataSource getMoreBricks];
}

- (void) loadMoreCompleted {
    if(reloading){
        [self doneReloadingTableViewData];
    }
    isLoadingMore = NO;
    [self.vdelegate loadMoreCompleted];
}

- (void) clearDataForNew{
    if([self.items count]>0){
        
        NSLog(@"%@",NSStringFromCGPoint(self.contentOffset));
        
        if (self.contentOffset.y>0) {
            self.contentOffset = CGPointZero;
        }
        [self.items removeAllObjects];
        [self initColums];
        //[self hidemask];
        canLoadMore = YES;
        self.offsetThreshold = floorf(self.height);
        
        // Reset all state
        [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            FMScrollViewCell *view = (FMScrollViewCell *)obj;
            [self enqueueReusableView:view];
        }];
        
        [self.visibleViews removeAllObjects];
        [self.viewKeysToRemove removeAllObjects];
        [self.indexToFrameMap removeAllObjects];
        [self.indexToExpandMap removeAllObjects];
        [self.indexTofixedCellFrameMap removeAllObjects];
        self.currentFixedCellTmp = nil;
        self.currentFixedIndexTmp = nil;
        self.previousOffset = CGPointMake(0, 0);
        CGSize newSize = CGSizeMake(self.width, self.height);
        [self setContentSize:newSize];
    }
    
}

- (void) clearDataInRange:(NSRange)range{
    
    NSInteger numberBeforeRemove = [self.items count];
    range.length = MIN(range.length, numberBeforeRemove);
    
    if(numberBeforeRemove>0){
        canLoadMore = NO;
        NSInteger maxIndex = NSMaxRange(range);
        [self.items removeObjectsInRange:range];
        
        [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key2, id obj, BOOL *stop) {
            FMScrollViewCell *view = (FMScrollViewCell *)obj;
            NSInteger integerKey2 = String2Index(key2);
            if (NSLocationInRange(integerKey2, range)) {
                [self enqueueReusableView:view];
                [self.viewKeysToRemove addObject:key2];
                if(self.currentFixedIndexTmp!=nil&&[key2 isEqualToString:self.currentFixedIndexTmp]){
                    self.currentFixedIndexTmp = nil;
                    self.currentFixedCellTmp = nil;
                }
            }
        }];
        
        [self.visibleViews removeObjectsForKeys:self.viewKeysToRemove];
        [self.viewKeysToRemove removeAllObjects];
        
        for (NSUInteger i = range.location; i<maxIndex; i++) {
            [self.viewKeysToRemove addObject:Index2String(i)];
        }
        
        [self.indexToFrameMap removeObjectsForKeys:self.viewKeysToRemove];
        [self.indexToExpandMap removeObjectsForKeys:self.viewKeysToRemove];
        [self.indexTofixedCellFrameMap removeObjectsForKeys:self.viewKeysToRemove];
        [self.viewKeysToRemove removeAllObjects];
        
        for (NSInteger i=maxIndex; i<numberBeforeRemove; i++) {
            NSString *index = Index2String(i);
            NSObject *indexFrame = [self.indexToFrameMap objectForKey:index];
            if(indexFrame!=nil){
                [self.indexToFrameMap setObject:indexFrame forKey:Index2String(i-range.length)];
                [self.indexToFrameMap removeObjectForKey:Index2String(i)];
            }
            
            if(self.currentFixedIndexTmp!=nil && String2Index(self.currentFixedIndexTmp)==i){
                self.currentFixedIndexTmp = Index2String(i-range.length);
                self.currentFixedCellTmp.index = i-range.length;
            }
            
            NSObject *indexExpand = [self.indexToExpandMap objectForKey:index];
            if(indexExpand!=nil){
                [self.indexToExpandMap setObject:indexExpand forKey:Index2String(i-range.length)];
                [self.indexToExpandMap removeObjectForKey:Index2String(i)];
            }
            
            NSObject *indexFixedCell = [self.indexTofixedCellFrameMap objectForKey:index];
            if(indexFixedCell!=nil){
                [self.indexTofixedCellFrameMap setObject:indexFixedCell forKey:Index2String(i-range.length)];
                [self.indexTofixedCellFrameMap removeObjectForKey:Index2String(i)];
            }
            
            NSObject *indexVisibleCell = [self.visibleViews objectForKey:index];
            if(indexVisibleCell!=nil){
                ((FMScrollViewCell*)indexVisibleCell).index = i-range.length;
                [self.visibleViews setObject:indexVisibleCell forKey:Index2String(i-range.length)];
                [self.visibleViews removeObjectForKey:Index2String(i)];
            }
            
        }
        
        NSInteger startReloadIndex = MAX(range.location-1, 0);
        
        [self reCalculateFrameFromIndex:startReloadIndex expandWidth:0 expandHeight:0];
        
        [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            FMScrollViewCell *view = (FMScrollViewCell *)obj;
            if(![self.currentFixedIndexTmp isEqualToString:key]){
                view.frame = CGRectFromString([self.indexToFrameMap objectForKey:key]);
            }
            
        }];
        
        canLoadMore = YES;
        
    }
    
}


- (NSUInteger) itemsCount{
    return [self.items count];
}


- (BOOL) isExpandedAtIndex:(NSUInteger)index{
    
    NSString *expandSizeString = [self.indexToExpandMap objectForKey:Index2String(index)];
    
    if(expandSizeString!=nil){
        CGSize expandSize = CGSizeFromString(expandSizeString);
        return (expandSize.width==0 && expandSize.height==0)?NO:YES;
    }
    
    return NO;
}


#pragma mark - ScrollView Cell functions

- (FMScrollViewCell *)fillBrickView:(id)object atIndex:(NSUInteger)index frame:(CGRect)frame {
    
    Class cls = [self classForCellOfObject:object];
    FMScrollViewCell *pin = [self dequeueReusableViewForClass:cls];
    if(pin == nil){
        pin = [[cls alloc] initWithFrame:CGRectZero];
    }
    
    NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:object,@"data",[NSNumber numberWithLong:(long)index],@"index", nil];
    [pin initView:p frame:frame];
    
    return pin;
}


- (Class)classForCellOfObject:(NSDictionary *)object
{
    NSString *type = [object objectForKey:@"FM_CLASSTYPE"];
//    NSString *type = object.FM_CLASSTYPE;
    if(!type||type.isEmpty){
        type = _defaultClassType;
    }
    Class cls = NSClassFromString(type);
    return cls?cls:[FMScrollViewCell class];
}

-(CGFloat)getBrickHeight:(id)object{
    return [[self classForCellOfObject:object] calculateHeight:object view:self];
}

-(CGFloat)getBrickWidth:(id)object{
    return [[self classForCellOfObject:object] calculateWidth:object view:self];
}

-(CGFloat)getBrickHeightOffset:(id)object{
    return [[self classForCellOfObject:object] heightOffset:object view:self];
}

-(CGFloat)getBrickXOffset:(id)object{
    return [[self classForCellOfObject:object] xOffset:object view:self];
}

-(CGFloat)getBrickHeightFromClass:(Class)cls andObject:(id)object{
    return [cls calculateHeight:object view:self];
}

-(CGFloat)getBrickWidthFromClass:(Class)cls andObject:(id)object{
    return [cls calculateWidth:object view:self];
}

-(CGFloat)getBrickHeightOffsetFromClass:(Class)cls andObject:(id)object{
    return [cls heightOffset:object view:self];
}

-(CGFloat)getBrickXOffsetFromClass:(Class)cls andObject:(id)object{
    return [cls xOffset:object view:self];
}


#pragma mark - Reusing Views

- (FMScrollViewCell *)dequeueReusableViewForClass:(Class)viewClass {
    NSString *identifier = NSStringFromClass(viewClass);
    
    FMScrollViewCell *view = nil;
    //NSLog(@"dequeueReusableViewForClass=%@",identifier);
    
    if ([self.reuseableViews objectForKey:identifier]) {
        
        //NSLog(@"size=%lu",(unsigned long)[[self.reuseableViews objectForKey:identifier] count]);
        view = [[self.reuseableViews objectForKey:identifier] anyObject];
        
        if (view) {
            // Found a reusable view, remove it from the set
            [[self.reuseableViews objectForKey:identifier] removeObject:view];
        }
    }
    
    return view;
}

- (void)enqueueReusableView:(FMScrollViewCell *)view {
    [view prepareForReuse];
    view.frame = CGRectZero;
    
    NSString *identifier = NSStringFromClass([view class]);
    if (![self.reuseableViews objectForKey:identifier]) {
        [self.reuseableViews setObject:[NSMutableSet set] forKey:identifier];
    }
    
    [[self.reuseableViews objectForKey:identifier] addObject:view];
    
    [view removeFromSuperview];
}


#pragma mark - UIScrollViewDelegate



- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastStopScrollY = scrollView.contentOffset.y;
    if (isRefreshing)
        return;
    isDragging = YES;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //NSLog(@"scrolling...");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMScrollViewDidScroll" object:self];
    
    if([self.indexTofixedCellFrameMap count]>0){
        
        NSArray *sortedKeys = [[self.indexTofixedCellFrameMap allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
        
        NSString* nextFixedIndex = nil;
        NSString* currentFixedIndex = nil;
        CGRect currentFixframe = CGRectZero;
        
        for (NSString* key in sortedKeys) {
            CGRect rect = CGRectFromString([self.indexTofixedCellFrameMap objectForKey:key]);
            if((rect.origin.y)>scrollView.contentOffset.y){
                nextFixedIndex = key;
            }else{
                currentFixedIndex = key;
                currentFixframe = rect;
                break;
            }
        }
        
        
        
        
        if(![self.currentFixedIndexTmp isEqualToString:currentFixedIndex] && [self.visibleViews objectForKey:self.currentFixedIndexTmp]!=nil){
            [[self.visibleViews objectForKey:self.currentFixedIndexTmp] setFrame:CGRectFromString([self.indexTofixedCellFrameMap objectForKey:self.currentFixedIndexTmp])];
        }
        
        
        FMScrollViewCell *currentFixedCell = [self.visibleViews objectForKey:currentFixedIndex];
        
        
        if((scrollView.contentOffset.y)>=currentFixframe.origin.y){
            currentFixframe.origin.y = scrollView.contentOffset.y;
        }
        
        if(currentFixedCell==nil&&currentFixedIndex!=nil){
            NSInteger i = String2Index(currentFixedIndex);
            if(self.currentFixedCellTmp==nil){
                currentFixedCell = [self fillBrickView:[self.items objectAtIndex:i] atIndex:i frame:currentFixframe];
                
                [self addSubview:currentFixedCell];
                
                // NSLog(@"add new fix");
                
                // Setup gesture recognizer
                if ([currentFixedCell.gestureRecognizers count] == 0) {
                    FMScrollViewTapGestureRecognizer *gr = [[FMScrollViewTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectView:)];
                    gr.delegate = self;
                    gr.cancelsTouchesInView = NO;
                    //gr.delaysTouchesBegan = YES;
                    [currentFixedCell addGestureRecognizer:gr];
                    currentFixedCell.userInteractionEnabled = YES;
                    
                }
                
                [currentFixedCell cellAppear];
                self.currentFixedCellTmp = currentFixedCell;
            }else{
                currentFixedCell = self.currentFixedCellTmp;
            }
        }else{
            if(self.currentFixedCellTmp != nil){
                [self.currentFixedCellTmp removeFromSuperview];
                self.currentFixedCellTmp = nil;
            }
            
            //NSLog(@"fix frame = %@", NSStringFromCGRect(currentFixframe));
            
        }
        
        currentFixedCell.frame = currentFixframe;
        self.currentFixedIndexTmp = currentFixedIndex;
        [self bringSubviewToFront:currentFixedCell];
    }
    
    
    if (!isLoadingMore && canLoadMore && !isLayouting && !reloading) {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        //NSLog(@"scrollPosition=%f",scrollPosition);
        if (scrollPosition < DEFAULT_HEIGHT_OFFSET&&scrollPosition>=0) {
            NSLog(@"loadmore=%f",scrollPosition);
            
            [self loadMore];
        }
    }
    previousOffset.y = scrollView.contentOffset.y>0?scrollView.contentOffset.y:0;
    
    [self.pzRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.lastStopScrollY = scrollView.contentOffset.y;
    //NSLog(@"scrollViewDidEndDecelerating");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.pzRefreshControl scrollViewDidEndDragging];
    self.lastStopScrollY = scrollView.contentOffset.y;
    if (isRefreshing)
        return;
    
    isDragging = NO;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    
    if ([view isKindOfClass:UIButton.class]) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
    
    
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    UITouch *touch = [touches anyObject];
    
    if(touch.phase == UITouchPhaseMoved)
    {
        return YES;
    }
    else
    {
        return [super touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}



#pragma mark - Gesture Recognizer

- (void)didSelectView:(FMScrollViewTapGestureRecognizer *)gestureRecognizer {
    NSLog(@"didSelectView in collectionview");
    //NSString *rectString = NSStringFromCGRect(gestureRecognizer.view.frame);
    //NSArray *matchingKeys = [self.indexToFrameMap allKeysForObject:rectString];
    //NSString *key = [matchingKeys lastObject];
    //if ([gestureRecognizer.view isMemberOfClass:[[self.visibleViews objectForKey:key] class]]) {
    if ([gestureRecognizer.view isKindOfClass:[FMScrollViewCell class]]) {
        //        [self showmask:(FMScrollViewCell *)gestureRecognizer.view];
        if (self.vdelegate && [self.vdelegate respondsToSelector:@selector(didSelectView:)]) {
            //NSInteger matchingIndex = String2Index([matchingKeys lastObject]);
            [self.vdelegate didSelectView:(FMScrollViewCell *)gestureRecognizer.view];
        }
    }
}



- (void)didLongPressView:(FMScrollViewLongPressGestureRecognizer*)gestureRecognizer{
    NSLog(@"didLongPressView in collectionview");
    
    
    static UIView    *snapshot = nil;
    static FMScrollViewCell * defaultCell  = nil;
    FMScrollViewCell * sourceCell = (FMScrollViewCell*)gestureRecognizer.view;
    FMScrollViewCell * targetCell = nil;
    
    
    
    CGPoint location = [gestureRecognizer locationInView:self];
    UIGestureRecognizerState state = gestureRecognizer.state;
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:{
            
            if (self.longPressProcessing) {
                return;
            }
            
            self.longPressProcessing = 1;
            defaultCell = [[FMScrollViewCell alloc]init];
            defaultCell.index = sourceCell.index;
            
            snapshot = [self customSnapshoFromView:sourceCell];
            [self addSubview:snapshot];
            
            // Add the snapshot as subview, centered at cell's center...
            __block CGPoint center = sourceCell.center;
            snapshot.center = center;
            snapshot.alpha = 0.0;
            [self addSubview:snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                
                // Offset for gesture location.
                center.y = location.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;
                
                // Fade out.
                sourceCell.alpha = 0.0;
            } completion:nil];
            
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            NSLog(@"moved!!!!!!!!!!!");
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            NSLog(@"%f",location.y);
            NSLog(@"%@",NSStringFromCGRect(self.frame));
            
            targetCell = [self getSubViewAtPoint:location];
            if (targetCell && [NSStringFromClass([targetCell class]) isEqualToString:NSStringFromClass([sourceCell class])] && targetCell != sourceCell) {
                
                CGRect targetFrame = targetCell.frame;
                CGRect sourceFrame = sourceCell.frame;
                NSInteger targetIndex = targetCell.index;
                NSInteger sourceIndex = sourceCell.index;
                [self.items exchangeObjectAtIndex:sourceIndex withObjectAtIndex:targetIndex];
                [UIView animateWithDuration:0.2 animations:^{
                    
                    
                    if (sourceIndex < targetIndex) {
                        
                        targetCell.frame = CGRectMake(CGRectGetMinX(targetFrame), CGRectGetMinY(sourceFrame), CGRectGetWidth(targetFrame), CGRectGetHeight(targetFrame));
                        sourceCell.frame = CGRectMake(CGRectGetMinX(sourceFrame), CGRectGetMaxY(targetCell.frame) + self.cellPaddingTop, CGRectGetWidth(sourceFrame), CGRectGetHeight(sourceFrame));
                        
                    }else{
                        
                        sourceCell.frame = CGRectMake(CGRectGetMinX(sourceFrame), CGRectGetMinY(targetFrame),CGRectGetWidth(sourceFrame), CGRectGetHeight(sourceFrame));
                        targetCell.frame = CGRectMake(CGRectGetMinX(targetFrame), CGRectGetMaxY(sourceCell.frame) + self.cellPaddingTop , CGRectGetWidth(targetFrame), CGRectGetHeight(targetFrame));
                    }
                    
                    
                    
                    targetCell.index = sourceIndex;
                    sourceCell.index = targetIndex;
                    
                    [self.visibleViews setObject:targetCell forKey:Index2String(sourceIndex)];
                    [self.visibleViews setObject:sourceCell forKey:Index2String(targetIndex)];
                    
                    
                    
                } completion:nil];
                
                
                
            }
        }
            break;
            
        default:{
            
            self.longPressProcessing = 0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = gestureRecognizer.view.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                
            } completion:^(BOOL finished) {
                //移除snapshotview
                [snapshot removeFromSuperview];
                snapshot = nil;
                gestureRecognizer.view.alpha = 1.0;
                
            }];
            
            if (sourceCell.index != defaultCell.index) {
                
                if (self.vdelegate && [self.vdelegate respondsToSelector:@selector(moveItemAtIndex:toIndex:)]) {
                    [self.vdelegate moveItemAtIndex:defaultCell.index toIndex:sourceCell.index];
                }
                
                
            }else{
                NSLog(@"order unchanged!!!!");
            }
            
            
        }
            break;
    }
    
    
    
}

- (FMScrollViewCell*)getSubViewAtPoint:(CGPoint)point{
    
    for (FMScrollViewCell * cell in self.subviews) {
        if (CGRectContainsPoint(cell.frame, point)) {
            return cell;
        }
    }
    
    return nil;
    
    
}

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}



- (void)didPanView:(FMScrollViewPanGestureRecognizer *)gestureRecognizer{
     NSLog(@"didPanView class = %@",NSStringFromClass([gestureRecognizer class]));
    
    
    if ([gestureRecognizer.view isKindOfClass:[FMScrollViewCell class]]) {
        
        CGPoint direction = [gestureRecognizer translationInView:self];
        
        if ((fabs(direction.x) <= fabs(direction.y) && !self.panProcessing)) {
            
            return;
        }
        
        //        if (direction.x >= 0 && !self.panProcessing) {
        //            return;
        //        }
        
        
        
        FMScrollViewCell *panView = (FMScrollViewCell*)gestureRecognizer.view;
        
        if(!panView.canBeMovedToLeft) return;
        
        CGFloat buttonWidth = [panView canBeMovedToLeftWidth];
        
        if([self.indexTofixedCellFrameMap objectForKey:Index2String(panView.index)]!=nil) return;
        
        CGRect orgFrame = CGRectFromString([self.indexToFrameMap objectForKey:Index2String(panView.index)]);
        CGPoint velocity = [gestureRecognizer velocityInView:self];
        CGPoint translation = [gestureRecognizer translationInView:self];
        //self.scrollEnabled = NO;
        
        
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
            self.panProcessing = 0;
            CGFloat movedOffsetX = orgFrame.origin.x-panView.x;
            if(movedOffsetX < 5||velocity.x>=0){
                [UIView animateWithDuration:0.2 animations:^{
                    panView.frame = orgFrame;
                    [panView movedToLeftViewWithOffsetX:0 orgFrame:orgFrame];
                    
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    panView.x = orgFrame.origin.x-buttonWidth;
                    
                    [panView movedToLeftViewWithOffsetX:buttonWidth orgFrame:orgFrame];
                    
                }];
            }
            return;
        }
        
        //NSLog(@"velocity offset = %f",(fabs(velocity.x)-fabs(velocity.y)));
        
        //2016.03.30 董晓伟:注释了以下 if 判断条件,使滑动更加顺畅.
        if(velocity.x<5){//fabs(velocity.y)<300 &&
            
            CGFloat currentX = panView.x+translation.x;
            if(currentX >= (orgFrame.origin.x-buttonWidth)){
                panView.x = currentX;
                self.panProcessing = 1;
                [panView movedToLeftViewWithOffsetX:(orgFrame.origin.x-panView.x) orgFrame:orgFrame];
                
                
            }
        }else{
            self.panProcessing = 0;
            [UIView animateWithDuration:0.2 animations:^{
                panView.frame = CGRectFromString([self.indexToFrameMap objectForKey:Index2String(panView.index)]);
                
                [panView movedToLeftViewWithOffsetX:0 orgFrame:orgFrame];
                
            }];
        }
        
        [gestureRecognizer setTranslation:CGPointZero inView:self];
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    //NSLog(@"1st recognizer class: %@ ; 2nd recognizer class: %@", NSStringFromClass([gestureRecognizer class]), NSStringFromClass([otherGestureRecognizer class]));
    
    if([NSStringFromClass([gestureRecognizer class]) isEqualToString:@"UIScrollViewPanGestureRecognizer"]&&[NSStringFromClass([otherGestureRecognizer class]) isEqualToString:@"FMScrollViewPanGestureRecognizer"]){
        
        if (self.panProcessing) {
            return NO;
        }
        
        return YES;
    }
    
    
    
    
    return NO;
}



- (BOOL)gestureRecognizer:(FMScrollViewTapGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // NSLog(@"should receive UIGestureRecognizer");
    
    if ( self.longPressProcessing) {
        return NO;
    }
    
    
    if (([[touch.view class] isSubclassOfClass:[UIButton class]]||([NSStringFromClass(touch.view.class) isEqualToString:@"FMStatusPhotoView"]) || ([NSStringFromClass(touch.view.class) isEqualToString:@"YYLabel"])) && (![NSStringFromClass(gestureRecognizer.class) isEqualToString:@"UIScrollViewPanGestureRecognizer"]) && (![NSStringFromClass(gestureRecognizer.class) isEqualToString:@"UIScrollViewDelayedTouchesBeganGestureRecognizer"])) {
        
        return NO;
    }
    
    
    if (![gestureRecognizer isKindOfClass:[FMScrollViewTapGestureRecognizer class]]) return YES;
    
    //    NSString *rectString = NSStringFromCGRect(gestureRecognizer.view.frame);
    //    NSArray *matchingKeys = [self.indexToFrameMap allKeysForObject:rectString];
    //    NSString *key = [matchingKeys lastObject];
    
    return YES;
    //if ([touch.view isMemberOfClass:[[self.visibleViews objectForKey:key] class]]) {
    //    if ([self.visibleViews objectForKey:key]) {
    //        return YES;
    //    } else {
    //        return NO;
    //    }
}



- (void)refreshControlDidRefresh{
    reloading = YES;
    //[self hidemask];
    [self.vdataSource pullRefresh];
    
}


#pragma mark - PZRefreshControl


- (void)beginLoading{
    [self.pzRefreshControl beginLoading];
}

- (void)finishLoading{
    [self.pzRefreshControl finishedLoading];
}

- (void)refreshTriggered{
    reloading = YES;
    //[self hidemask];
    [self.vdataSource pullRefresh];
    
}
- (void)doneReloadingTableViewData{
    reloading = NO;
}

@end
