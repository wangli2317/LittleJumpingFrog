//
//  PZRefreshNormalControl.m
//  mogi
//
//  Created by cherry on 16/1/13.
//  Copyright © 2016年 com.8w4q. All rights reserved.
//

#import "PZRefreshNormalControl.h"
#import "PZRefreshControlStyle.h"
#import "PZRefreshControlDefaultStyle.h"



#define PZ_REFRESH_RADIUS 21.0f
#define PZ_REFRESH_CONTROL_HEIGHT 65.0f
#define HALF_REFRESH_CONTROL_HEIGHT (PZ_REFRESH_CONTROL_HEIGHT / 2.0f)

#define DEFAULT_FOREGROUND_COLOR [UIColor whiteColor]
#define DEFAULT_BACKGROUND_COLOR [UIColor colorWithWhite:0.10f alpha:1.0f]

#define DEFAULT_TOTAL_HORIZONTAL_TRAVEL_TIME_FOR_BALL 0.75f

#define TRANSITION_ANIMATION_DURATION 0.2f


typedef enum {
    PZRefreshControlStateIdle = 0,
    PZRefreshControlStateLoading = 1,
    PZRefreshControlStateResetting = 2
} PZRefreshControlState;


@interface PZRefreshNormalControl(){
    PZRefreshControlState state;
    
    CGFloat originalTopContentInset;
    
    UIImageView* ballView;
    
    CGPoint ballIdleOrigin;
    
    UIView* animationView;
    
    NSDate* currentAnimationStartTime;
    CGFloat currentAnimationDuration;
}


@property (strong) CAShapeLayer *pullToRefreshShape;
@property (strong) CAShapeLayer *loadingShape;
@property (strong, readwrite, nonatomic) Class<PZRefreshControlStyle> styleClass;
@property (strong) NSTimer *timer;
@property (strong) UILabel *label;
@property (strong) UILabel *keyLabel;

@property (assign, nonatomic) UIScrollView* scrollView;
@property (assign, nonatomic) id refreshTarget;
@property (nonatomic) SEL refreshAction;
@property (nonatomic, readonly) CGFloat distanceScrolled;

@end

@implementation PZRefreshNormalControl 

#pragma mark UITableView

+ (PZRefreshNormalControl*)attachToTableView:(UITableView*)tableView
                     withRefreshTarget:(id)refreshTarget
                      andRefreshAction:(SEL)refreshAction{
    return [self attachToScrollView:tableView
                  withRefreshTarget:refreshTarget
                   andRefreshAction:refreshAction
                         styleClass:nil];
}

#pragma mark UIScrollView

+ (PZRefreshNormalControl*)attachToScrollView:(UIScrollView*)scrollView
                      withRefreshTarget:(id)refreshTarget
                       andRefreshAction:(SEL)refreshAction
                             styleClass:(Class)styleClass{
    PZRefreshNormalControl* existingRefreshControl = [self findPZRefreshControlInScrollView:scrollView];
    if(existingRefreshControl != nil) {
        return existingRefreshControl;
    }
    
    //Initialized height to 0 to hide it
    PZRefreshNormalControl* refreshControl = [[PZRefreshNormalControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, scrollView.frame.size.width, 0.0f)
                                                                     andScrollView:scrollView
                                                                  andRefreshTarget:refreshTarget
                                                                  andRefreshAction:refreshAction
                                                                        styleClass:styleClass];
    
    [scrollView addSubview:refreshControl];
    
    return refreshControl;
}

+ (PZRefreshNormalControl*)findPZRefreshControlInScrollView:(UIScrollView*)scrollView{
    for(UIView* subview in scrollView.subviews) {
        if([subview isKindOfClass:[PZRefreshNormalControl class]]) {
            return (PZRefreshNormalControl*)subview;
        }
    }
    
    return nil;
}


#pragma mark - Initializing a new pong refresh control

- (id)initWithFrame:(CGRect)frame
      andScrollView:(UIScrollView*)scrollView
   andRefreshTarget:(id)refreshTarget
   andRefreshAction:(SEL)refreshAction
         styleClass:(Class)styleClass{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.scrollView = scrollView;
        self.refreshTarget = refreshTarget;
        self.refreshAction = refreshAction;
        self.styleClass = styleClass;
        originalTopContentInset = scrollView.contentInset.top;
        
        [self setupLoadingView];
        
        state = PZRefreshControlStateIdle;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleOrientationChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupLoadingView{
    self.backgroundColor = [UIColor clearColor];
    animationView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, PZ_REFRESH_CONTROL_HEIGHT)];
    //animationView.backgroundColor = [UIColor greenColor];
    [self addSubview:animationView];
    
    [self setupShape];
    
    [self.pullToRefreshShape addAnimation:[self pullDownAnimation] forKey:@"load"];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, self.frame.size.width, 15)];
    self.keyLabel = [[UILabel alloc] initWithFrame:self.pullToRefreshShape.frame];
    [animationView addSubview:self.label];
    [animationView addSubview:self.keyLabel];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [self.styleClass tipFont];
    self.label.textColor  = [self.styleClass tipColor];
    self.label.text = [self getRandomTxtFromArray:[self.styleClass tipsArray]];
    //
    //    NSLog(@"self.pullToRefreshShape.frame=%@",NSStringFromCGRect(self.pullToRefreshShape.frame));
    //self.keyLabel.frame = self.pullToRefreshShape.frame;
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    self.keyLabel.font = [self.styleClass keywordFont];
    self.keyLabel.textColor  = [self.styleClass keywordColor];
    self.keyLabel.text = [self getRandomTxtFromArray:[self.styleClass keywordArray]];
}


- (void)setupShape{
    
    self.pullToRefreshShape = [CAShapeLayer layer];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, PZ_REFRESH_RADIUS, PZ_REFRESH_RADIUS)];
    
    CAShapeLayer *loadShape = [CAShapeLayer layer];
    
    CAShapeLayer *ingShape  = [CAShapeLayer layer];
    
    animationView.backgroundColor = [UIColor clearColor];
    for (CAShapeLayer *shape in @[loadShape, ingShape]) {
        shape.strokeColor = [UIColor blackColor].CGColor;
        shape.fillColor   = [UIColor clearColor].CGColor;
        shape.lineCap   = kCALineCapRound;
        shape.lineJoin  = kCALineJoinRound;
        shape.lineWidth = 1.2;
        shape.position = CGPointMake(75, 0);
        
        shape.strokeEnd = .0;
        shape.frame = CGRectMake(0, 0, PZ_REFRESH_RADIUS, PZ_REFRESH_RADIUS);
        shape.position = CGPointMake(animationView.center.x, animationView.center.y+10);
        shape.path  = createPathRotatedAroundBoundingBoxCenter(circlePath.CGPath, -M_PI_2);
        
        [animationView.layer addSublayer:shape];
    }
    
    
    ingShape.strokeEnd = .8;
    ingShape.strokeColor = [self.styleClass loadingLayerColor].CGColor;
    loadShape.strokeColor = [self.styleClass ptrLayerColor].CGColor;
    
    self.loadingShape = ingShape;
    self.pullToRefreshShape = loadShape;
    self.pullToRefreshShape.speed = 0; // pull to refresh layer is paused here
    
    [self.loadingShape setHidden:YES];
    [self.pullToRefreshShape setHidden:NO];
    
}

/**
 This is the animation that is controlled using timeOffset when the user pulls down
 */
- (CAAnimation *)pullDownAnimation{
    // Text is drawn by stroking the path from 0% to 100%
    CABasicAnimation *writeText = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    writeText.fromValue = @0;
    writeText.toValue = @1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0; // For convenience when using timeOffset to control the animation
    group.animations = @[writeText];
    
    group.removedOnCompletion = NO;
    return group;
}

- (CAAnimation *)rotatingAnimation{
    int direction = 1;  //-1为逆时针
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * direction];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    //    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return rotationAnimation;
}


static CGPathRef createPathRotatedAroundBoundingBoxCenter(CGPathRef path, CGFloat radians) {
    CGRect bounds = CGPathGetBoundingBox(path); // might want to use CGPathGetPathBoundingBox
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, radians);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateCopyByTransformingPath(path, &transform);
}

- (void)rollingAnimation{
    [self.loadingShape addAnimation:[self rotatingAnimation] forKey:@"rotatingAnimation"];
    [self.loadingShape setHidden:NO];
    self.pullToRefreshShape.timeOffset = .0;
    
}

-(NSString*)getRandomTxtFromArray:(NSArray*)array{
    return [array objectAtIndex:[self getRandomNumber:0 to:((int)[array count]-1)]];
}

-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from+(arc4random()%(to-from+1)));
}


#pragma mark Letting go of the scroll view, checking for refresh trigger

- (void)scrollViewDidEndDragging{
    
    if(state == PZRefreshControlStateIdle) {
        if([self didUserScrollFarEnoughToTriggerRefresh]) {
            [self beginLoading];
            [self notifyTargetOfRefreshTrigger];
        }
    }
}

- (BOOL)didUserScrollFarEnoughToTriggerRefresh{
    
    return (-self.distanceScrolled > PZ_REFRESH_CONTROL_HEIGHT);
}

- (void)notifyTargetOfRefreshTrigger{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if ([self.refreshTarget respondsToSelector:self.refreshAction])
        [self.refreshTarget performSelector:self.refreshAction];
    
#pragma clang diagnostic pop
}


#pragma mark - Listening to scroll delegate events

#pragma mark Actively scrolling

- (void)scrollViewDidScroll{
    
    CGFloat rawOffset = -self.distanceScrolled;
    
    [self offsetGameViewBy:rawOffset];
    
    if(state == PZRefreshControlStateIdle) {
        
        CGFloat fractionDragged = MIN(1, rawOffset/PZ_REFRESH_CONTROL_HEIGHT);
        
        [self dragging:fractionDragged];
    }
}

- (void)dragging:(CGFloat)fractionDragged{
    
    self.pullToRefreshShape.timeOffset = fractionDragged;
}


- (CGFloat)distanceScrolled{
    
    return (self.scrollView.contentOffset.y + self.scrollView.contentInset.top);
}

- (void)offsetGameViewBy:(CGFloat)offset{
    
    CGFloat offsetConsideringState = offset;
    if(state != PZRefreshControlStateIdle) {
        offsetConsideringState += PZ_REFRESH_CONTROL_HEIGHT;
    }
    
    [self setHeightAndOffsetOfRefreshControl:offsetConsideringState];
    [self stickGameViewToBottomOfRefreshControl];
}

- (void)setHeightAndOffsetOfRefreshControl:(CGFloat)offset{
    
    CGRect newFrame = self.frame;
    newFrame.size.height = offset;
    newFrame.origin.y = -offset;
    self.frame = newFrame;
}

- (void)stickGameViewToBottomOfRefreshControl{
    
    CGRect newGameViewFrame = animationView.frame;
    newGameViewFrame.origin.y = self.frame.size.height - animationView.frame.size.height;
    animationView.frame = newGameViewFrame;
}


#pragma mark - Manually starting a refresh

- (void)beginLoading{
    
    [self beginLoadingAnimated:YES];
}

- (void)beginLoadingAnimated:(BOOL)animated{
    
    if (state != PZRefreshControlStateLoading) {
        state = PZRefreshControlStateLoading;
        
        [self scrollRefreshControlToVisibleAnimated:animated];
        [self rollingAnimation];
        //[self startPong];
    }
}

- (void)scrollRefreshControlToVisibleAnimated:(BOOL)animated{
    
    CGFloat animationDuration = 0.0f;
    if(animated) {
        animationDuration = TRANSITION_ANIMATION_DURATION;
    }
    
    
    UIEdgeInsets newInsets = self.scrollView.contentInset;
    newInsets.top = originalTopContentInset + PZ_REFRESH_CONTROL_HEIGHT;
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    [UIView animateWithDuration:animationDuration animations:^(void) {
        self.scrollView.contentInset = newInsets;
        self.scrollView.contentOffset = contentOffset;
    }];
}
#pragma mark - Resetting after loading finished

- (void)finishedLoading{
    
    if(state != PZRefreshControlStateLoading) {
        return;
    }
 
    
    if (self.scrollView.isDragging) {
        [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:0.0];
    } else {
        
        state = PZRefreshControlStateResetting;
        [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION animations:^(void){
            [self resetScrollViewContentInsets];
            [self setHeightAndOffsetOfRefreshControl:0.0f];
            [self disappearing];
        } completion:^(BOOL finished){
            state = PZRefreshControlStateIdle;
        }];
    }
    
    
}

- (void)resetScrollViewContentInsets{
    
    UIEdgeInsets newInsets = self.scrollView.contentInset;
    newInsets.top = originalTopContentInset;
    self.scrollView.contentInset = newInsets;
}

- (void)disappearing{
    state = PZRefreshControlStateIdle;
    self.pullToRefreshShape.timeOffset = 0;
    [self.loadingShape setHidden:YES];
    [self.loadingShape removeAllAnimations];
    self.label.text = [self getRandomTxtFromArray:[self.styleClass tipsArray]];
    self.keyLabel.text = [self getRandomTxtFromArray:[self.styleClass keywordArray]];
}


#pragma mark - Handling orientation changes

- (void)handleOrientationChange {
    self.frame = CGRectMake(0.0f, 0.0f, self.scrollView.frame.size.width, 0.0f);
    //CGFloat gameViewWidthBeforeOrientationChange = gameView.frame.size.width;
    animationView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, PZ_REFRESH_CONTROL_HEIGHT);
    originalTopContentInset = self.scrollView.contentInset.top;
    
    if(state == PZRefreshControlStateLoading) {
        originalTopContentInset -= PZ_REFRESH_CONTROL_HEIGHT;
        [self setHeightAndOffsetOfRefreshControl:PZ_REFRESH_CONTROL_HEIGHT];
        
        
        //[self disappearing];
        //[self removeAnimations];
    } else {
        [self disappearing];
    }
}


- (void)setStyleClass:(Class)styleClass {
    if (styleClass) {
        _styleClass = styleClass;
    } else {
        _styleClass = [PZRefreshControlDefaultStyle class];
    }
}


@end
