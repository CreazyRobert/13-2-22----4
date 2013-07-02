//
//  ThrowBallCell.m
//  抛绣球
//
//  Created by mac on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThrowBallCell.h"

@implementation ThrowBallCell
@synthesize btnSection =_btnSection,titles=_titles;

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"titles"];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addObserver:self forKeyPath:@"titles" options:NSKeyValueObservingOptionNew context:nil];
        _titles=[[NSArray alloc]init];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
   
    if([keyPath isEqualToString:@"titles"]){
        CGFloat buttonLength=0;
        CGFloat lineHeight=0;
        for (int i=0; i<[_titles count]; i++) {
            NSString *placeStr=[_titles objectAtIndex:i];
            CGSize buttonSize=[placeStr sizeWithFont:[UIFont systemFontOfSize:18]];
            
            UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
            if(buttonLength>(310-buttonSize.width)){
                buttonLength = 0;
                lineHeight+=30;
                aButton.frame=CGRectMake(buttonLength, lineHeight, buttonSize.width, 20);
            }else {
                aButton.frame=CGRectMake(buttonLength, lineHeight, buttonSize.width, 20);
            }
            buttonLength += buttonSize.width+15;
            [aButton setTitle:placeStr forState:UIControlStateNormal];
            aButton.backgroundColor=[UIColor clearColor];
            [self addSubview:aButton];
            [aButton addTarget:self action:@selector(citySelect:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        lineHeight+=25;
        self.frame=CGRectMake(5, 5, 310, lineHeight+5);
    }

}

-(void)citySelect:(UIButton *)sender{
//    //NSLog(@"%@",sender.titleLabel.text);
    NSDictionary *diction=[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:_btnSection] forKey:@"btnSection"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"labelText" object:sender.titleLabel.text userInfo:diction];
}




@end
