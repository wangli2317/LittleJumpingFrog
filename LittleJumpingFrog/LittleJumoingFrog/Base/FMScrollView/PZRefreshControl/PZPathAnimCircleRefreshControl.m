//
//  PZPathAnimCircleRefreshControl.m
//  PullToRefreshControlDemo
//
//  Created by cherry on 16/1/8.
//  Copyright © 2016年 Zhang Kai Yu. All rights reserved.
//

#import "PZPathAnimCircleRefreshControl.h"

#define PZ_REFRESH_RADIUS 21.0f
#define PZ_REFRESH_DIS 55.0f
@interface PZPathAnimCircleRefreshControl()

/** The layer that is animated as the user pulls down */
@property (strong) CAShapeLayer *pullToRefreshShape;
@property (strong) CAShapeLayer *loadingShape;
@property (strong) NSTimer *timer;
@property (strong) UILabel *label;
@property (strong) UILabel *keyLabel;

@end

@implementation PZPathAnimCircleRefreshControl


- (instancetype)initWithRefreshTarget:(id)refreshTarget
                     andRefreshAction:(SEL)refreshAction
                           styleClass:(Class)styleClass{
    self = [super initWithRefreshTarget:refreshTarget andRefreshAction:refreshAction MaxDistance:PZ_REFRESH_DIS height:PZ_REFRESH_DIS styleClass:styleClass];
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.disappearingTimeInterval = 0.1;
    return self;
}


- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    [self setupShape];
    [self.pullToRefreshShape addAnimation:[self pullDownAnimation] forKey:@"load"];
    [self addSubview:self.label];
    [self addSubview:self.keyLabel];
    self.label.frame = CGRectMake(0, 7, self.frame.size.width, 15);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [self.styleClass tipFont];
    self.label.textColor  = [self.styleClass tipColor];
    self.label.text = [self getRandomTxtFromArray:[self.styleClass tipsArray]];
//    
//    NSLog(@"self.pullToRefreshShape.frame=%@",NSStringFromCGRect(self.pullToRefreshShape.frame));
    self.keyLabel.frame = self.pullToRefreshShape.frame;
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    self.keyLabel.font = [self.styleClass keywordFont];
    self.keyLabel.textColor  = [self.styleClass keywordColor];
    self.keyLabel.text = [self getRandomTxtFromArray:[self.styleClass keywordArray]];
}


-(NSString*)getRandomTxtFromArray:(NSArray*)array{
    return [array objectAtIndex:[self getRandomNumber:0 to:((int)[array count]-1)]];
}

-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from+(arc4random()%(to-from+1)));
}

- (void)setupShape
{
    self.pullToRefreshShape = [CAShapeLayer layer];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, PZ_REFRESH_RADIUS, PZ_REFRESH_RADIUS)];
    
    CAShapeLayer *loadShape = [CAShapeLayer layer];
    
    CAShapeLayer *ingShape  = [CAShapeLayer layer];
    
    self.animationView.backgroundColor = [UIColor clearColor];
    for (CAShapeLayer *shape in @[loadShape, ingShape]) {
        shape.strokeColor = [UIColor blackColor].CGColor;
        shape.fillColor   = [UIColor clearColor].CGColor;
        shape.lineCap   = kCALineCapRound;
        shape.lineJoin  = kCALineJoinRound;
        shape.lineWidth = 1.2;
        shape.position = CGPointMake(75, 0);
        
        shape.strokeEnd = .0;
        shape.frame = CGRectMake(0, 0, PZ_REFRESH_RADIUS, PZ_REFRESH_RADIUS);
        shape.position = CGPointMake(self.animationView.center.x, self.animationView.center.y+10);
        shape.path  = createPathRotatedAroundBoundingBoxCenter(circlePath.CGPath, -M_PI_2);
        
        [self.animationView.layer addSublayer:shape];
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


- (void)dragging:(CGFloat)fractionDragged
{
    
    self.pullToRefreshShape.timeOffset = fractionDragged;
}

- (void)maxDistanceReached{
    //
}


- (void)startRefreshing{
    [self rollingAnimation];
    //NSLog(@"self.pullToRefreshShape.hidden=%@",self.pullToRefreshShape.hidden?@"YES":@"NO");
}


- (void)disappearing{
    
    self.pullToRefreshShape.timeOffset = 0;
    [self.loadingShape setHidden:YES];
    [self.loadingShape removeAllAnimations];
    self.label.text = [self getRandomTxtFromArray:[self.styleClass tipsArray]];
    self.keyLabel.text = [self getRandomTxtFromArray:[self.styleClass keywordArray]];
}


@end
