//
//  SCGIFViewController.h
//  BanBu
//
//  Created by Jc Zhang on 13-1-5.
//
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@protocol BrowserGifDelegate <NSObject>

-(void)sendMessageTochat;

@end

@interface SCGIFViewController : UIViewController<UIActionSheetDelegate,SDWebImageManagerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    
    ALAssetsLibrary *_assetLibrary;
    UIActivityIndicatorView *activity;
    BOOL isBreaker;
}

@property(assign,nonatomic) id <BrowserGifDelegate> delegate;
@property(retain,nonatomic) NSString *gifString;
@property(retain,nonatomic) NSString *hints;
@property(retain,nonatomic) NSMutableArray *arrayData;
@property int indexPathSelected;
@property BOOL isBreaker;
@end
