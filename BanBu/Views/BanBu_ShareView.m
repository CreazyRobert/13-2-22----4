//
//  BanBu_ShareView.m
//  BanBu
//
//  Created by apple on 13-1-21.
//
//

#import "BanBu_ShareView.h"
 
@interface BanBu_ShareView(share)

-(void)initEvery;

-(void)fuck:(UIButton *)sender;

@end
@implementation BanBu_ShareView
@synthesize chat=_chat;
@synthesize share=_share;
@synthesize number=_number;
@synthesize buttonNumber=_buttonNumber;
@synthesize returnArr=_returnArr;
@synthesize headLabel=_headLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)initWithController:(BanBu_ChatViewController *)viewController Sel:(SEL)myShare Tag:(int)number ButtonNum:(int)numbert SelButtonName:(SEL)returnbuttonName
{
    self=[super init];

    if(self)
    {
       self.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        
        _share=myShare;
    
        _number=number;// 哪一个button
        
        _chat=viewController;// 控制器
        
        _buttonNumber=numbert;// 几个button
        
        // 返回buttonname
        
        _returnArr=returnbuttonName;
        
        [self initEvery];
    
        return self;
    }
    
    
    return nil;

}

-(void)initEvery
{
    
    if(!_returnArr||!_chat)
        return;
    
    // 建一个标题栏
    
    UILabel *headView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,280 , 40)];
    
    headView.backgroundColor=[UIColor blackColor];
    
    headView.textColor=[UIColor whiteColor];
    
    _headLabel=headView;
    
    [self addSubview:headView];
    
    [headView release];
    
    NSMutableArray *arrName=[_chat performSelector:_returnArr withObject:[NSString stringWithFormat:@"%i",_buttonNumber] ];
 

    for(int k=0;k<[arrName count];k++)
     {
        
         UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
         
         button.frame=CGRectMake(0, 41+k*41, 280, 40);
         
         button.tag=k;
         
         
         [button setTitle:[arrName objectAtIndex:k] forState:UIControlStateNormal];
                  
         [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         
         [button addTarget:self action:@selector(fuck:) forControlEvents:UIControlEventTouchUpInside];
         
         [self addSubview:button];
         
         // 黑线
         
         if(k==[arrName count]-1)
             return;
         UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 82+k*40,280, 2)];
         
         label.backgroundColor=[UIColor blackColor];
         
         [self addSubview:label];
         
         [label release];
         
     }
    
    // 这是多语言
    
   
    
    
    
}
-(void)fuck:(UIButton *)sender
{
  if(!_chat||!_share)
      return;
      if(_number==1)
      {
        [_chat performSelector:_share withObject:[NSNumber numberWithInt:sender.tag]];
      }else if(_number==0)
       {
       
           [_chat performSelector:_share withObject:[NSNumber numberWithInt:sender.tag+100]];
       
       }else
       {
       
           [_chat performSelector:_share withObject:[NSNumber numberWithInt:sender.tag+200]];
       
       }
           
           
}


-(void)setHeadLabelString:(NSString *)headString
{

    _headLabel.text=headString;

}
@end
