//
//  CFCube.m
//  CubicFlipDemo
//
//  Created by 莫理明 on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CFCube.h"

@interface CFCube ()
- (CATransform3D)transformForTop;
- (CATransform3D)transformForBottom;
@end

@implementation CFCube
@synthesize visibleContentView = _visibleContentView, hiddenContentView = _hiddenContentView;
@synthesize delegate = _delegate;

- (void)dealloc {
    
    [_visibleContentView release];
    [_hiddenContentView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _flipping = NO;
        
        CATransform3D trans = CATransform3DIdentity;
        trans.m34 = 0.001;
        self.layer.sublayerTransform = trans;
        
    }
    return self;
}

- (void)setVisibleContentView:(UIView *)visibleContentView
{
    [_visibleContentView release];
    _visibleContentView = [visibleContentView retain];
    _visibleContentView.layer.transform = CATransform3DIdentity;
    [self addSubview:_visibleContentView];
    [self bringSubviewToFront:_visibleContentView];
}

- (void)setHiddenContentView:(UIView *)hiddenContentView
{
    [_hiddenContentView release];
    _hiddenContentView = [hiddenContentView retain];
    _hiddenContentView.layer.transform = [self transformForTop];
    [self addSubview:_hiddenContentView];
    [self bringSubviewToFront:_visibleContentView];
}

#pragma mark - Public Methods

- (void)flipWithStyle:(CFCubeFlipStyle)style
{
    // avoid error
    if (_flipping) {
        return;
    }
    
    CATransform3D toTransForVisibleView, fromTransForHiddenView; 
    
    if (style == CFCubeFLipDown) {
        _isUP = YES;
        toTransForVisibleView = [self transformForBottom];
        fromTransForHiddenView = [self transformForTop];
    } else {
        _isUP = NO;
        toTransForVisibleView = [self transformForTop];
        fromTransForHiddenView = [self transformForBottom];
    }
    
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    rotationAnimation.duration = 0.35;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@""];
    rotationAnimation.duration = 0;
    rotationAnimation.delegate = self;
    
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:fromTransForHiddenView];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    [_hiddenContentView.layer addAnimation:rotationAnimation forKey:nil];
    _hiddenContentView.layer.transform = CATransform3DIdentity;
    
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:toTransForVisibleView];
    [_visibleContentView.layer addAnimation:rotationAnimation forKey:nil];
    _visibleContentView.layer.transform = toTransForVisibleView;
  
    [self bringSubviewToFront:_hiddenContentView];
    
    UIView *tempView = nil;
    tempView = _hiddenContentView;
    _hiddenContentView = _visibleContentView;
    _visibleContentView = tempView;
}

#pragma mark - CAAnimation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        _flipping = NO;
    }
    
    if(!_flipping && [_delegate respondsToSelector:@selector(cfCubeFlipDidStop:)])
        [_delegate cfCubeFlipDidStop:self];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    _flipping = YES;
    
}

#pragma mark - Private methods

- (CATransform3D)transformForTop
{
    CGFloat radius = self.bounds.size.height * 0.5;
    return CATransform3DRotate(CATransform3DMakeTranslation(0, -radius, radius), -M_PI_2, 1, 0, 0);
}

- (CATransform3D)transformForBottom
{
    CGFloat radius = self.bounds.size.height * 0.5;
    return CATransform3DRotate(CATransform3DMakeTranslation(0, radius, radius), M_PI_2, 1, 0, 0);
}
@end
