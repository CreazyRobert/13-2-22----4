//
//  QweiboViewController.h
//  ToadyIsFree
//
//  Created by apple on 11-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QVerifyWebViewController.h"
#import "QWeiboAsyncApi.h"


@interface QweiboViewController : UIViewController {
	
	UIBarButtonItem *btnSend;
	UIBarButtonItem *btnCancel;
	UITextView *messageTextField;
	UIImageView *sendImageView;
	UILabel *_statue;
	UILabel *_info;
	BOOL _authorized;
	NSString *_text;
	UIImage *_sendImage;
	
	NSURLConnection *_connection;
	NSMutableData *_responseData;
	

}

@property (nonatomic, retain) IBOutlet UITextView *messageTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSend;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) IBOutlet UIImageView *sendImageView;

@property (nonatomic, retain) NSURLConnection	*connection;
@property (nonatomic, retain) NSMutableData		*responseData;



- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;
- (id)initWithText:(NSString *)text image:(UIImage *)image;


@end
