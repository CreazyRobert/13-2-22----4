//
//  BanBu_NoticeView1.m
//  BanBu
//
//  Created by Jc Zhang on 13-1-7.
//
//

#import "BanBu_NoticeView1.h"

@implementation BanBu_NoticeView1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        //        self.alpha = 0.5 ;
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (__MainScreen_Height+20-300)/2, 290, 300)];
        backImageView.userInteractionEnabled = YES;
        backImageView.layer.cornerRadius = 5.0;
        backImageView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        [self addSubview:backImageView];
        [backImageView release];
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 30)];
        aLabel.text = NSLocalizedString(@"helpfulTitle", nil);
        aLabel.font = [UIFont systemFontOfSize:18];
        aLabel.backgroundColor = [UIColor clearColor];
        [backImageView addSubview:aLabel];
        [aLabel release];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 290, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:0.5];
        [backImageView addSubview:lineLabel];
        [lineLabel release];
        
        UIImageView *warningView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice.png"]];
        warningView.frame = CGRectMake(145-32, 55, 64, 64);
        [backImageView addSubview:warningView];
        [warningView release];
        
        CGFloat btnLen = [NSLocalizedString(@"warningLabel", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 120)].height;
        UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 260, btnLen)];
        warningLabel.numberOfLines = 0;
        warningLabel.backgroundColor = [UIColor clearColor];
        warningLabel.font = [UIFont systemFontOfSize:14];
        warningLabel.textColor = [UIColor grayColor];
        warningLabel.text = NSLocalizedString(@"warningLabel", nil);
        [backImageView addSubview:warningLabel];
        [warningLabel release];
        
        CGFloat btnLen1 = [NSLocalizedString(@"infoLabel", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 40)].height;

        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 215+btnLen-80, 260, btnLen1)];
        infoLabel.backgroundColor = [UIColor orangeColor];
        infoLabel.numberOfLines = 0;
        infoLabel.layer.cornerRadius = 4.0;
        infoLabel.font = [UIFont systemFontOfSize:14];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.textAlignment = UITextAlignmentCenter;
        infoLabel.text = NSLocalizedString(@"infoLabel", nil);
        [backImageView addSubview:infoLabel];
        [infoLabel release];
        
       
        
        UIButton *commBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        commBtn.frame = CGRectMake(15, 250+btnLen-80+btnLen1-20, 260, 40);
        [commBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [commBtn setTitle:NSLocalizedString(@"chat_btn", nil) forState:UIControlStateNormal];
        [commBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [commBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [backImageView addSubview:commBtn];
        ;
        
        backImageView.frame = CGRectMake(15, (__MainScreen_Height+20-(300+btnLen+btnLen1-80-15))/2, 290, 300+btnLen+btnLen1-80-15);
    }
    return self;
}

- (void)dismissSelf
{
    
    [self removeFromSuperview];
    
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
