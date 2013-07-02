//
//  BanBu_NoteView.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-26.
//
//

#import "BanBu_NoteView.h"

@implementation BanBu_NoteView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
//        self.alpha = 0.5 ;
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (__MainScreen_Height+20-200-170)/2, 290, 200)];
        backImageView.userInteractionEnabled = YES;
        backImageView.layer.cornerRadius = 5.0;
        backImageView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        [self addSubview:backImageView];
        [backImageView release];
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 30)];
        aLabel.text = NSLocalizedString(@"editNote", nil);
        aLabel.font = [UIFont systemFontOfSize:18];
        aLabel.backgroundColor = [UIColor clearColor];
        [backImageView addSubview:aLabel];
        [aLabel release];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 290, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:0.5];
        [backImageView addSubview:lineLabel];
        [lineLabel release];
        
        aTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 60, 260, 40)];
        UILabel *paddingView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 40)];
        paddingView.backgroundColor = [UIColor clearColor];
        aTextField.leftView = paddingView;
        aTextField.leftViewMode = UITextFieldViewModeAlways;
        [paddingView release];
        aTextField.placeholder = NSLocalizedString(@"aliasPlaceholder", nil);
        aTextField.textColor = [UIColor darkGrayColor];
        aTextField.delegate = self;
        aTextField.returnKeyType = UIReturnKeyDone;
        aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [aTextField becomeFirstResponder];
        [aTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        aTextField.background = [[UIImage imageNamed:@"textfield.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        [backImageView addSubview:aTextField];
        [aTextField release];
        
        UILabel *originalName = [[UILabel alloc]initWithFrame:CGRectMake(15, 105, 260, 30)];
        originalName.backgroundColor = [UIColor clearColor];
        originalName.font = [UIFont systemFontOfSize:15];
        originalName.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"nameLabel", nil),title];
        [backImageView addSubview:originalName];
        [originalName release];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        leftBtn.frame = CGRectMake(30, 145, 100, 40);
        [leftBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitle:NSLocalizedString(@"confirmNotice", nil) forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [backImageView addSubview:leftBtn];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rightBtn.frame = CGRectMake(160, 145, 100, 40);
        [rightBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:NSLocalizedString(@"cancelNotice", nil) forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [backImageView addSubview:rightBtn];
        ;
    }
    return self;
}

-(void)finishAction{

    if([aTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
        
        if([_delegate respondsToSelector:@selector(changeNameAction:)]){
            
            [_delegate changeNameAction:aTextField.text];
            
        }

    }
        
}
 
- (void)dismissSelf
{

    [self removeFromSuperview];

}

//监听textField
//-(void)textFieldDidChange:(NSNotification *)noti{
//    NSObject *obj = [noti object];
//    if([obj isKindOfClass:[UITextField class]]){
//        UITextField *bTextField = (UITextField *)obj;
//        if(bTextField.text.length>14){
//            
//            bTextField.text = [bTextField.text substringToIndex:aTextField.text.length-1];
//        }
//    }
//}


@end
