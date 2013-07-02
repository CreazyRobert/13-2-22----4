//
//  ComposeViewController.h
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
//#import "TKLoadingView.h"

#define kWBSDKDemoAppKey @"2303352595"
#define kWBSDKDemoAppSecret @"510daac86118f245bfab69df56ad6f32"

@interface WBComposeViewController : UIViewController<WBEngineDelegate>{

	UITextView *messageTextField;
	UIImageView *sendImageView;
	UILabel *_statue;
	UILabel *_info;
	
	NSString *_text;
	UIImage *_sendImage;
}

@property (nonatomic, retain)  UITextView *messageTextField;
@property (nonatomic, retain)  UIImageView *sendImageView;
@property (nonatomic, retain)  WBEngine *engine;
 
- (void)send;
- (void)dismiss:(BOOL)animated;
- (id)initWithText:(NSString *)text image:(UIImage *)image;


@end
