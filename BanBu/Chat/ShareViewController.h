//
//  ShareViewController.h
//  微信小助手
//
//  Created by Away on 13-4-16.
//  Copyright (c) 2013年 Jc Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController
{
    NSString *urlString;
}

@property(nonatomic,retain)NSString *sayContent;

-(id)initWithURLString:(NSString *)_url;

@end
