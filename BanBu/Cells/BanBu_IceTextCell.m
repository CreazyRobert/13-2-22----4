//
//  BanBu_IceTextCell.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-12.
//
//

#import "BanBu_IceTextCell.h"

@implementation BanBu_IceTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _saytextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _saytextLabel.numberOfLines = 0;
        _saytextLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_saytextLabel];
        [_saytextLabel release];
        
        _extendLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _extendLabel.numberOfLines = 0;
        _extendLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_extendLabel];
        [_extendLabel release];
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
//        _lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
//        [self addSubview:_lineView];
//         [self sendSubviewToBack:_lineView];
//        [_lineView release];
        
        [self addObserver:self forKeyPath:@"saytextStr" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"extendStr" options:NSKeyValueObservingOptionNew context:nil];

    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"saytextStr"]){
        _saytextLabel.text = _saytextStr;
        _saytextLabel.textColor = [UIColor darkGrayColor];
        _saytextLabel.font = [UIFont systemFontOfSize:16];
        CGSize saytextSize = [_saytextLabel.text sizeWithFont:_saytextLabel.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
        _saytextLabel.frame = CGRectMake(10, 5, 300, saytextSize.height);
    }
    else if([keyPath isEqualToString:@"extendStr"]){
        _extendLabel.text = _extendStr;
        _extendLabel.textColor = [UIColor colorWithRed:9.0/256 green:100.0/256 blue:190.0/256 alpha:1];
        _extendLabel.font = [UIFont systemFontOfSize:16];
        CGSize saytextSize = [_extendLabel.text sizeWithFont:_saytextLabel.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
        _extendLabel.frame = CGRectMake(10, _saytextLabel.frame.size.height+5, 300, saytextSize.height);
    }
    
    
    CGRect selfFrame = self.frame;
    selfFrame.size.width = 320;
    selfFrame.size.height = _saytextLabel.frame.size.height +_extendLabel.frame.size.height+10;
    self.frame = selfFrame;
//    _lineView.frame = CGRectMake(0, self.frame.size.height, 320, 1.0);
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"saytextStr"];
    [self removeObserver:self forKeyPath:@"extendStr"];
    [super dealloc];

}









@end
