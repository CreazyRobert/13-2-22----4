//
//  BanBu_MaskView.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_MaskView.h"

@implementation BanBu_MaskView

@synthesize didTouchedSelector = _didTouchedSelector;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_didTouchedSelector)
        [_delegate performSelector:self.didTouchedSelector withObject:self];
}

@end
