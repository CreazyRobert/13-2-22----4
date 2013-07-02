//
//  UINavigationBar+TKCategory.m
//  iAskSharer
//
//  Created by apple on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+TKCategory.h"


@implementation UINavigationBar (TKCategory)



- (void)drawRect:(CGRect)rect
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topbar" ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:path];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}

@end
