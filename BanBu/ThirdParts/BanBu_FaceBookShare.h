//
//  BanBu_FaceBookShare.h
//  BanBu
//
//  Created by Jc Zhang on 13-2-18.
//
//

#import <UIKit/UIKit.h>

@interface BanBu_FaceBookShare : UIViewController<UITextViewDelegate>{
    
    NSString *_text;
	UIImage *_sendImage;
    
}

@property(nonatomic,retain)UITextView *postMessageTextView;

- (id)initWithText:(NSString *)text image:(UIImage *)image;

@end
