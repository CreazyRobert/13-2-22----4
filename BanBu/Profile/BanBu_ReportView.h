//
//  BanBu_ReportView.h
//  BanBu
//
//  Created by Jc Zhang on 13-1-10.
//
//

#import <UIKit/UIKit.h>

@protocol ReportViewDelegate <NSObject>

-(void)reportAndPullBlack:(NSString *)message;

@end

@interface BanBu_ReportView : UIView<UITextViewDelegate>{
    
    UITextView *aTextView;
    UIImageView *backImageView;
    NSInteger reportMessIndex;

}

@property(assign,nonatomic)id<ReportViewDelegate>delegate;

@end
