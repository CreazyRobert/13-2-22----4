//
//  ComposeViewController.h
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draft.h"
#import "WeiboClient.h"
#import "OAuthEngine.h"
#import "OAuthController.h"
#import "WeiboClient.h"
#import "TKLoadingView.h"

#define kOAuthConsumerKey				@"2303352595"		//REPLACE ME
#define kOAuthConsumerSecret	@"510daac86118f245bfab69df56ad6f32"	//REPLACE ME

@interface ComposeViewController : UIViewController <OAuthControllerDelegate>{
	UIBarButtonItem *btnSend;
	UIBarButtonItem *btnCancel;
	UITextView *messageTextField;
	UIImageView *sendImageView;
	Draft *draft;
	UILabel *_statue;
	UILabel *_info;
	
	OAuthEngine	*_engine;
	BOOL _authorized;
	NSString *_text;
	UIImage *_sendImage;
}

@property (nonatomic, retain) IBOutlet UITextView *messageTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSend;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) IBOutlet UIImageView *sendImageView;

- (void)newTweet;

- (IBAction)send:(id)sender;

- (IBAction)cancel:(id)sender;

- (id)initWithText:(NSString *)text image:(UIImage *)image;


@end
