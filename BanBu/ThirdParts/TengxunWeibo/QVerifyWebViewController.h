//
//  QVerifyWebViewController.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import <UIKit/UIKit.h>
#import "QWeiboSyncApi.h"
#import "NSURL+QAdditions.h"
#import "TKLoadingView.h"

#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="
#define AppKey			@"801238036"
#define AppSecret		@"f026e4d53812da99c0cf399839e2adb3"
#define AppTokenKey		@"tokenKey"
#define AppTokenSecret	@"tokenSecret"
#define user [NSUserDefaults standardUserDefaults]

@protocol QVerifyWebViewControllerDelegate;

@interface QVerifyWebViewController : UIViewController<UIWebViewDelegate> {
	
	UIWebView *_QwebView;
	UINavigationBar *_navBar;
	BOOL _authorized;
	
	NSString *_tokenKey;
	NSString *_tokenSecret;

}

@property (nonatomic, retain) IBOutlet UIWebView *QwebView;
@property (nonatomic,assign) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) NSString *tokenKey;
@property (nonatomic, retain) NSString *tokenSecret;
@property (nonatomic, assign) id<QVerifyWebViewControllerDelegate> delegate;

 
-(IBAction)cancel:(id)sender;
- (void)parseTokenKeyWithResponse:(NSString *)response;
- (void)saveDefaultKey;

@end

@protocol QVerifyWebViewControllerDelegate <NSObject>
@optional

- (void)qVerifyWebViewControllerDidDismiss:(QVerifyWebViewController *)qVerifyWebViewController;

@end
