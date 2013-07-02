//
//  CFCube.h
//  CubicFlipDemo
//
//  Created by 莫理明 on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    CFCubeFlipUp,
    CFCubeFLipDown
}CFCubeFlipStyle;

@protocol CFCubeDelegate;

@interface CFCube : UIView {

    BOOL _flipping;
}

@property (nonatomic, retain) UIView *visibleContentView;
@property (nonatomic, retain) UIView *hiddenContentView;
@property (nonatomic, assign) id<CFCubeDelegate> delegate;
@property (nonatomic, assign) BOOL isUP;

- (void)flipWithStyle:(CFCubeFlipStyle)style;

@end

@protocol CFCubeDelegate <NSObject>
@optional

- (void)cfCubeFlipDidStart:(CFCube *)cfCube;
- (void)cfCubeFlipDidStop:(CFCube *)cfCube;

@end
