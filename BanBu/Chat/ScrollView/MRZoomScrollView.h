//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFImageView.h"

@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    SCGIFImageView *imageView;
    BOOL isLarger;
    BOOL isReady;
}

@property (nonatomic, retain) SCGIFImageView *imageView;
@property BOOL isLarger;
@property BOOL isReady;

@end
