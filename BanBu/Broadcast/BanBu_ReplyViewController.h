//
//  BanBu_ReplyViewController.h
//  BanBu
//
//  Created by Jc Zhang on 12-11-7.
//
//

#import <UIKit/UIKit.h>
@protocol BanBu_ReplyDelegate;

@interface BanBu_ReplyViewController : UIViewController<UITextViewDelegate>{
    UITextView *_inputView;
    
}


@property(nonatomic,retain)id <BanBu_ReplyDelegate> delegate;
- (id)initWithTitle:(NSString *)myTitle replyid:(NSString *)rid;
@property(nonatomic,retain)NSString *replyid;
@end

//@protocol BanBu_ReplyDelegate <NSObject>
//@optional
//
//-(void)banBuReplySuccessed;
