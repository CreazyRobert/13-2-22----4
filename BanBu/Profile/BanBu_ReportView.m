//
//  BanBu_ReportView.m
//  BanBu
//
//  Created by Jc Zhang on 13-1-10.
//
//

#import "BanBu_ReportView.h"
#import "RadioButton.h"
@implementation BanBu_ReportView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        //        self.alpha = 0.5 ;
        
        backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (__MainScreen_Height+20-340)/2, 290, 340)];
        backImageView.userInteractionEnabled = YES;
        backImageView.layer.cornerRadius = 5.0;
        backImageView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        [self addSubview:backImageView];
        [backImageView release];
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 30)];
        aLabel.text = NSLocalizedString(@"reportUser", nil);
        aLabel.font = [UIFont systemFontOfSize:18];
        aLabel.backgroundColor = [UIColor clearColor];
        [backImageView addSubview:aLabel];
        [aLabel release];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 290, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:0.5];
        [backImageView addSubview:lineLabel];
        [lineLabel release];
        
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 270, 135)];
        container.backgroundColor = [UIColor clearColor];
        [backImageView addSubview:container];
        
        RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"first group" index:0];
        RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"first group" index:1];
        RadioButton *rb3 = [[RadioButton alloc] initWithGroupId:@"first group" index:2];
        RadioButton *rb4 = [[RadioButton alloc] initWithGroupId:@"first group" index:3];
        [rb1 handleButtonTap:rb1.button];//自己加的
        rb1.frame = CGRectMake(5,0,250,22);
        rb2.frame = CGRectMake(5,35,250,22);
        rb3.frame = CGRectMake(5,70,250,22);
        rb4.frame = CGRectMake(5,105,250,22);
        
        [container addSubview:rb1];
        [container addSubview:rb2];
        [container addSubview:rb3];
        [container addSubview:rb4];
        
        [rb1 release];
        [rb2 release];
        [rb3 release];
        [rb4 release];
        
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(35, 0, 230, 20)];
        label1.backgroundColor = [UIColor clearColor];
//        label1.textColor = [UIColor whiteColor];
        label1.text = NSLocalizedString(@"badMessage", nil);
        [container addSubview:label1];
        [label1 release];
        
        UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(35, 35, 230, 20)];
        label2.backgroundColor = [UIColor clearColor];
        label2.text = NSLocalizedString(@"badMessage1", nil);
//        label2.textColor = [UIColor whiteColor];
        
        [container addSubview:label2];
        [label2 release];
        
        UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(35, 70, 230, 20)];
        label3.backgroundColor = [UIColor clearColor];
        label3.text = NSLocalizedString(@"badMessage2", nil);
//        label3.textColor = [UIColor whiteColor];
        
        [container addSubview:label3];
        [label3 release];
        
        UILabel *label4 =[[UILabel alloc] initWithFrame:CGRectMake(35, 105, 230, 20)];
        label4.backgroundColor = [UIColor clearColor];
        label4.text = NSLocalizedString(@"badMessage3", nil);
//        label4.textColor = [UIColor whiteColor];
        
        [container addSubview:label4];
        [label4 release];
        
        [RadioButton addObserverForGroupId:@"first group" observer:self];
        
        
        
        
        aTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 200, 270, 70)];
        aTextView.font = [UIFont systemFontOfSize:15];
        aTextView.textColor = [UIColor darkGrayColor];
        aTextView.backgroundColor = [UIColor whiteColor];
        aTextView.delegate = self;
        aTextView.layer.borderColor = [[UIColor grayColor]CGColor];
        aTextView.layer.borderWidth = 1;
        aTextView.layer.cornerRadius = 3;
        aTextView.returnKeyType = UIReturnKeyDone;
        [backImageView addSubview:aTextView];
        [aTextView release];
    
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        leftBtn.frame = CGRectMake(30, 285, 100, 40);
        [leftBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitle:NSLocalizedString(@"submitButton", nil) forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [backImageView addSubview:leftBtn];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rightBtn.frame = CGRectMake(160, 285, 100, 40);
        [rightBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:NSLocalizedString(@"cancelNotice", nil) forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [backImageView addSubview:rightBtn];
        ;
    }
    return self;
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    reportMessIndex = index;
    //NSLog(@"changed to %d in %@",index,groupId);
}

-(void)finishAction{
    [self dismissSelf];
    if([_delegate respondsToSelector:@selector(reportAndPullBlack:)]){
        [self dismissSelf];
        NSArray *messageArr = [NSArray arrayWithObjects:NSLocalizedString(@"badMessage", nil),NSLocalizedString(@"badMessage1", nil),NSLocalizedString(@"badMessage2", nil),NSLocalizedString(@"badMessage3", nil), nil];
        NSString *mess;
        if([aTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
            mess = [NSString stringWithFormat:@"%@,%@",[messageArr objectAtIndex:reportMessIndex],aTextView.text];
            
        }else{
            mess = [messageArr objectAtIndex:reportMessIndex];
            
        }
        [_delegate performSelector:@selector(reportAndPullBlack:) withObject:mess];
    }

}

-(void)goTo{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        
    }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];

}

- (void)dismissSelf
{

    if([aTextView isFirstResponder]){
        [aTextView resignFirstResponder];

    }else{
        [self performSelector:@selector(goTo) withObject:nil afterDelay:0.3];

    }

    
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y-(__MainScreen_Height>460?130:180), backImageView.frame.size.width , backImageView.frame.size.height);
    [UIView commitAnimations];
    NSLog(@"%f",backImageView.frame.origin.y);
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    backImageView.frame = CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y+(__MainScreen_Height>460?130:180), backImageView.frame.size.width , backImageView.frame.size.height);
    [UIView commitAnimations];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        

        return NO;
    }
    return YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
