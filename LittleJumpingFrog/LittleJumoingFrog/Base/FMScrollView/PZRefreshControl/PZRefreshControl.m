//
//  PZRefreshControl.m
//  PullToRefreshControlDemo
//
//  Created by cherry on 16/1/8.
//  Copyright © 2016年 Zhang Kai Yu. All rights reserved.
//

#import "PZRefreshControl.h"
#import "PZRefreshControlDefaultStyle.h"


@interface PZRefreshControl ()


@property (nonatomic, assign) BOOL observingSuperview;
@property (nonatomic, readwrite, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, readwrite, getter=isInsetChanged) BOOL insetChanged;


@property (assign, nonatomic) id refreshTarget;
@property (nonatomic) SEL refreshAction;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *monitorDraggingTimer;

@end


@implementation PZRefreshControl


- (instancetype)initWithRefreshTarget:(id)refreshTarget
                         andRefreshAction:(SEL)refreshAction
                              MaxDistance:(CGFloat)maxDistance
                                   height:(CGFloat)height
                               styleClass:(Class)styleClass{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _maxDistance = maxDistance;
        _height = height;
        self.styleClass = styleClass;
        self.animationView = [[UIView alloc] init];
        self.refreshTarget = refreshTarget;
        self.refreshAction = refreshAction;
        self.backgroundColor = [UIColor greenColor];
        self.opaque = NO;
        self.hidden = YES;
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (self.observingSuperview) {
        self.observingSuperview = NO;
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    
    if (!self.observingSuperview && self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        self.observingSuperview = YES;
        [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        self.scrollView = (UIScrollView *)self.superview;
    }
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.animationView];
    [self resetFrame];
    [self.superview sendSubviewToBack:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resetFrame];
}

- (void)resetFrame
{
    self.frame = CGRectMake(0, -self.height, CGRectGetWidth(self.superview.bounds), self.height);
    self.animationView.frame = self.bounds;
}

- (void)setHeightAndOffsetOfRefreshControl:(CGFloat)offset{
    NSLog(@"offset=%f",offset);
    CGRect newFrame = self.frame;
    //offset = MIN(offset, self.height);
    newFrame.size.width = self.superview.frame.size.width;
    newFrame.size.height = offset;
    newFrame.origin.y = -offset;
    self.frame = newFrame;
    self.animationView.frame = self.bounds;
    NSLog(@"animationView=%@",NSStringFromCGRect(CGRectMake(0, -offset, self.superview.frame.size.width, offset)));
    NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.scrollView.contentOffset));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.superview && [keyPath isEqualToString:@"contentOffset"]) {
//        NSValue *contentOffsetValue = change[NSKeyValueChangeNewKey];
//        CGPoint point;
//        [contentOffsetValue getValue:&point];
//        NSLog(@"contentOffsetValue = %@",NSStringFromCGPoint(point));
//        NSLog(@"contentOffset = %@",NSStringFromCGPoint(self.scrollView.contentOffset));
        
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        CGPoint point = self.scrollView.contentOffset;
        
        CGFloat yOffset = -contentInset.top;
        //NSLog(@"contentInset=%f",contentInset.top);
        
        CGFloat offset = point.y+contentInset.top;
        CGFloat fractionDragged = MIN(1, -offset/self.maxDistance);
        
        //[self setHeightAndOffsetOfRefreshControl:-offset];
        
        if (point.y < yOffset && !self.isRefreshing) {
            self.hidden = NO;
            
            [self dragging:fractionDragged];
        }
        if (point.y == yOffset && !self.isRefreshing) {
            self.hidden = YES;
            [self dragging:fractionDragged];
        }
        if (point.y < yOffset - self.maxDistance && self.isRefreshing == NO && self.scrollView.isDragging) {
            NSLog(@"%@", NSStringFromCGRect(self.scrollView.frame));
            NSLog(@"%@", NSStringFromCGRect(self.scrollView.bounds));
            NSLog(@"%@", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
        
            [self maxDistanceReached];
            [self beginRefreshing];
            
        }
    }
}


- (void)beginRefreshing{
    
    if (!self.isRefreshing) {
        self.refreshing = YES;
        self.monitorDraggingTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(monitorSuperviewDragging) userInfo:nil repeats:YES];
        if (self.monitorDraggingTimer) {
            [self.monitorDraggingTimer fire];
            [[NSRunLoop currentRunLoop] addTimer:self.monitorDraggingTimer forMode:NSRunLoopCommonModes];
        }

        [self notifyTargetOfRefreshTrigger];
        
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
//        UIEdgeInsets currentContentInset = self.scrollView.contentInset;
//        self.scrollView.contentInset = UIEdgeInsetsMake(currentContentInset.top + self.height, currentContentInset.left, currentContentInset.bottom, currentContentInset.right);
        [self startRefreshing];
    }
}

- (void)notifyTargetOfRefreshTrigger
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if ([self.refreshTarget respondsToSelector:self.refreshAction])
        [self.refreshTarget performSelector:self.refreshAction];
    
#pragma clang diagnostic pop
}

- (void)endRefreshing
{
    if (self.scrollView.isDragging) {
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0];
    } else {
        [UIView animateWithDuration:self.disappearingTimeInterval ? self.disappearingTimeInterval : 0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (self.isInsetChanged) {
                UIEdgeInsets currentContentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(currentContentInset.top - self.height, currentContentInset.left, currentContentInset.bottom, currentContentInset.right);
                self.insetChanged = NO;
            }
            [self disappearing];
        } completion:^(BOOL finished) {
            self.refreshing = NO;
            self.hidden = YES;
        }];
    }
}

- (void)monitorSuperviewDragging
{
    if (self.scrollView.isDragging) {
        
    } else {
        if (self.isRefreshing) {
            [self setSuperviewContentInsets];
            [self.monitorDraggingTimer invalidate];
            self.monitorDraggingTimer = nil;
        }
    }
}

- (void)setSuperviewContentInsets
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        if (!self.isInsetChanged) {
            UIEdgeInsets currentContentInset = self.scrollView.contentInset;
            self.scrollView.contentInset = UIEdgeInsetsMake(currentContentInset.top + self.height, currentContentInset.left, currentContentInset.bottom, currentContentInset.right);
            self.insetChanged = YES;
            
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Custom accessors

- (void)setStyleClass:(Class)styleClass {
    if (styleClass) {
        _styleClass = styleClass;
    } else {
        _styleClass = [PZRefreshControlDefaultStyle class];
    }
}


- (void)dragging:(CGFloat)fractionDragged{};
- (void)maxDistanceReached{};
- (void)startRefreshing{};
- (void)disappearing{};
@end
