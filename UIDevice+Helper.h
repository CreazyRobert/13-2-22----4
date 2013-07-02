//
//  UIDevice+Helper.h
//  微信小助手
//
//  Created by Jc Zhang on 13-3-14.
//  Copyright (c) 2013年 Jc Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Helper)

- (BOOL)isJailbroken;

- (NSString *)platformString;

@end
