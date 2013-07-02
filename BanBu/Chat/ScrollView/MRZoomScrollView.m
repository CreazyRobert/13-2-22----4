//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface MRZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView
@synthesize isLarger;
@synthesize imageView;
@synthesize isReady;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
        
        [self initImageView];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        isLarger = NO;
        self.delegate = self;
//        self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
        
        [self initImageView];
    }
    return self;


}
- (void)initImageView
{
    imageView = [[SCGIFImageView alloc]init];
//
//    // The imageView can be zoomed largest size
    imageView.frame = self.frame;
    imageView.frame = CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenHeight * 2.5);
//    self.imageView.center = CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView release];
    
    // Add gesture,double tap zoom imageView.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDoubleTap:) name:@"getLager" object:nil];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];

//    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:1];
    [self setMaximumZoomScale:2.0];
    self.scrollEnabled = YES;
    
    self.bouncesZoom = YES;
    
    [doubleTapGesture release];
    [self setZoomScale:0.5];
}

#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
//    NSLog(@"%f",self.zoomScale);
    if(isLarger)
    {
        float newScale = self.zoomScale /3;
        isLarger = NO;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [self zoomToRect:zoomRect animated:YES];
//        self.imageView.center = CGPointMake(160,(__MainScreen_Height-45-40-44)/2);
    }
    else
    {
        float newScale = self.zoomScale * 3;
        isLarger = YES;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [self zoomToRect:zoomRect animated:YES];
//        self.imageView.center = CGPointMake(self.contentSize.width/2,self.contentSize.height/2);
//        if(self.contentSize.height<=(__MainScreen_Height-45-44-40))
//        {
//            self.imageView.center = CGPointMake(self.contentSize.width/2, (__MainScreen_Height-44-45-40)/2);
//        }

//NSLog(@"%f %f",self.imageView.center.x,self.imageView.center.y);

    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x -  (zoomRect.size.width  / 3.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 3.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog(@"%f",scale);
    [scrollView setZoomScale:scale animated:NO];
    
    
    

}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark - View cycle
- (void)dealloc
{
    [super dealloc];
}


@end
