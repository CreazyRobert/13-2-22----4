//
//  BanBu_NoticeView.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_NoticeView.h"
#import <QuartzCore/QuartzCore.h>


@implementation BanBu_NoticeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.0];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
        contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        barView.image = [UIImage imageNamed:@"topbar.png"];
        [contentView addSubview:barView];
        [barView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:barView.bounds];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.text = NSLocalizedString(@"helpfulTitle", nil);
        [barView addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 220)];
        bkView.image = [[UIImage imageNamed:@"bg_chat_notice.png"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:1.0];
        bkView.layer.shadowColor = [[UIColor blackColor] CGColor];
        bkView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        bkView.layer.shadowOpacity = 0.6;
        [contentView addSubview:bkView];
        [bkView release];
        
        UIImageView *warningView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice.png"]];
        warningView.frame = CGRectMake(128, 15, 64, 64);
        [bkView addSubview:warningView];
        [warningView release];
        
        UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 280, 60)];
        warningLabel.numberOfLines = 0;
        warningLabel.backgroundColor = [UIColor clearColor];
        warningLabel.font = [UIFont systemFontOfSize:14];
        warningLabel.textColor = [UIColor grayColor];
        warningLabel.text = NSLocalizedString(@"warningLabel", nil);
        [bkView addSubview:warningLabel];
        [warningLabel release];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, 280, 20)];
        infoLabel.backgroundColor = [UIColor orangeColor];
        infoLabel.layer.cornerRadius = 4.0;
        infoLabel.font = [UIFont systemFontOfSize:14];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.textAlignment = UITextAlignmentCenter;
        infoLabel.text = NSLocalizedString(@"infoLabel", nil);
        [bkView addSubview:infoLabel];
        [infoLabel release];
        
        UIImageView *cancelbk = [[UIImageView alloc] initWithFrame:CGRectMake(260, 284, 40, 19)];
        cancelbk.image = [UIImage imageNamed:@"bg_chat_notice_btn.png"];
        [contentView addSubview:cancelbk];
        [cancelbk release];
        
        UIButton *cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel_btn.frame = CGRectMake(265, 265, 30, 30);
        [cancel_btn setBackgroundImage:[UIImage imageNamed:@"btn_plus_br.png"] forState:UIControlStateNormal];
        [cancel_btn setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
        [cancel_btn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        cancel_btn.transform = CGAffineTransformMakeRotation(M_PI_4);
        [contentView addSubview:cancel_btn];
        
        _conttentView = contentView;
        [self addSubview:contentView];
        [contentView release];
    }
    return self;
}

- (void)dismissSelf
{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.0];
                         _conttentView.frame = CGRectMake(0, -480, 320, 480);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)didMoveToSuperview
{
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];

                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                            
                                              _conttentView.frame = CGRectMake(0, 0, 320, 480);
                                            
                                          }];
                         
                     }];
    
}


@end
