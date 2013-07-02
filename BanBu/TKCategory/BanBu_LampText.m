//
//  BanBu_LampText.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-20.
//
//

#import "BanBu_LampText.h"

@implementation BanBu_LampText
@synthesize motionWidth = _motionWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _motionWidth = 180;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    float w  = self.frame.size.width;
    if (_motionWidth>=w) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = 10;
    self.frame = frame;
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:4.0f * (w<180?180:w) / 180.0 ];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount: LONG_MAX];
    
    frame = self.frame;
    frame.origin.x = -(w-170) ;
    self.frame = frame;
    [UIView commitAnimations];
}

//+(void) showNavTitle:(UIViewController *)controller title:(NSString *)title  {
//    [Utilitys showNavTitle:controller title:title width:320.0];
//}

+(void) showNavTitle:(UIViewController *)controller title:(NSString *)title width:(CGFloat) width {
    
    CGFloat w = [title sizeWithFont: [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:0] size:20]].width;
    CGFloat x = 0;
    if (w <= width) {
        x = (width - w) / 2;
    }
    BanBu_LampText *titleLabel = [[BanBu_LampText alloc]initWithFrame:CGRectMake((width-w)/2, 0, w, 40)];
    titleLabel.motionWidth = width;
    titleLabel.lineBreakMode = UILineBreakModeClip;
    titleLabel.text = title;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:0] size:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [scroll addSubview:titleLabel];
    scroll.backgroundColor = [UIColor clearColor];
    controller.navigationItem.titleView = scroll;
    
    [titleLabel release];
    [scroll release];
    
}

- (void)dealloc {
    [super dealloc];
}

@end
