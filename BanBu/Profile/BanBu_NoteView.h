//
//  BanBu_NoteView.h
//  BanBu
//
//  Created by Jc Zhang on 12-12-26.
//
//

#import <UIKit/UIKit.h>

@protocol ChangeNameDelegate;


@interface BanBu_NoteView : UIView<UITextFieldDelegate>{
    
    UITextField *aTextField;
}

@property(nonatomic, assign)id<ChangeNameDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title;

@end


@protocol ChangeNameDelegate <NSObject>

-(void)changeNameAction:(NSString*)noteName;

@end