//
//  BanBu_TextEditer.h
//  BanBu
//
//  Created by jie zheng on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BanBu_TextEditerDelegate;

@interface BanBu_TextEditer : UIViewController<UITextViewDelegate>
{
    UITextView *_inputView;
}

@property(nonatomic, retain)NSString *textContent;
@property(nonatomic, assign)id<BanBu_TextEditerDelegate> delegate;

- (id)initWithTitle:(NSString *)myTitle oldText:(NSString *)oldText description:(NSString *)des;


@end

@protocol BanBu_TextEditerDelegate <NSObject>
@optional

-(void)banBuTextEditerDidChangeValue:(NSString *)newValue forItem:(NSString *)item;

@end
