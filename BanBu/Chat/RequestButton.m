//
//  RequestButton.m
//  BanBu
//
//  Created by apple on 13-2-2.
//
//

#import "RequestButton.h"

@implementation RequestButton
@synthesize activityd=_activityd;
@synthesize isActivity=_isActivity;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(RequestButton*)ButtonWithName:(NSString *)name
{
    
    return [[self alloc]initWithName:name];
    
}

-(void)upDateActivity
{

    NSLog(@"oh shit ");

}
-(id)initWithName:(NSString *)name
{
   if(self=[super init])
   {
   
       UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
       
       activity.center=self.center;
       
       activity.frame=CGRectMake(15,0,30, 30);
       
       _activityd=activity;
       
       activity.hidden=YES;
       
    
       [self addSubview:activity];
       
       [activity release];
       
    
       return self;
   }
    return nil;
}

-(void)setIsFridends:(BOOL)isFridends
{

    _isFridends=isFridends;
    
     if(_isFridends==NO)
     {
         [self setTitle:NSLocalizedString(@"jiaweihaoyou", nil) forState:UIControlStateNormal];

         self.titleLabel.font=[UIFont systemFontOfSize:12];
         
          [self setBackgroundImage:[UIImage imageNamed:@"加为好友.png"] forState:UIControlStateNormal];
         
         
     }else{
         [self setTitle:NSLocalizedString(@"kaishiduihua", nil) forState:UIControlStateNormal];

          self.titleLabel.font=[UIFont systemFontOfSize:12];
         [self setBackgroundImage:[UIImage imageNamed:@"开始对话.png"] forState:UIControlStateNormal];
     }
         
}

-(void)setIsActivity:(BOOL)isActivity
{
      
    _isActivity=isActivity;
    
    if(_isActivity==NO)
    {
        [_activityd setHidden:NO];
        [_activityd startAnimating];
    
    }else
    {
        [_activityd stopAnimating];
        [_activityd setHidden:YES];
       
     
    }
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
