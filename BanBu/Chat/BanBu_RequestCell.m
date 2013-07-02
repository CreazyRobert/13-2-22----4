//
//  BanBu_RequestCell.m
//  BanBu
//
//  Created by apple on 13-1-29.
//
//

#import "BanBu_RequestCell.h"
#define x 90
@implementation BanBu_RequestCell
@synthesize request=_request;
@synthesize agreeButton=_agreeButton;
@synthesize deleteButton=_deleteButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        
        

    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        /*
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        //_deleteButton setBackgroundImage:[UIImage imageNamed:<#(NSString *)#>] forState:<#(UIControlState)#>
       
        _deleteButton.frame=CGRectMake(x+130, 53, 30, 30);
        
    
        [_deleteButton setHidden:YES];
        
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"noo1.png"] forState:UIControlStateNormal];
    
        [_deleteButton addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteButton];
        */
        
       // _agreeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        _agreeButton=[RequestButton ButtonWithName:@"cc"];
        
        _agreeButton.selected=NO;
        
        _agreeButton.frame=CGRectMake(x+155, 53, 60, 30);
        
       [_agreeButton addTarget:self action:@selector(toAgree:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        [self.contentView addSubview:_agreeButton];
        
        
        return self;
    }
 
    return nil;
}



-(void)setButtonName:(NSString *)buttonName Isfriend:(BOOL)friendt
{
    isFriend=friendt;
    
 
    
    
    if(friendt==NO)
    {
        
        // [_agreeButton setBackgroundImage:[UIImage imageNamed:@"好友请求.png"] forState:UIControlStateNormal];
        
        _agreeButton.isFridends=friendt;
        
    }else
    {
        //  [_agreeButton setBackgroundImage:[UIImage imageNamed:@"请求对话.png"] forState:UIControlStateNormal];
        
        _agreeButton.isFridends=friendt;
        
    }
    
    
}

-(void)toPushNext:(UITapGestureRecognizer *)tap
{
//    [super toPushNext:tap];
    
    if(!_request)
        return;
    
    [_request pushTheNextController:self];
    
}

-(void)toAgree:(BanBu_RequestCell *)idt
{  
    if(!_request)
        return;

     if(isFriend==0)
     {
         _agreeButton.isActivity=isFriend;
         
        [_request reToAgreetoChange:self Button:_agreeButton];
     }else
     {
         _agreeButton.isActivity=isFriend;
         
       [_request pushTheChatViewController:self];
     }

}

-(void)toChat:(BanBu_RequestCell *)idt
{
    if(!_request)
        return;
    
   
    
}


-(void)toDelete:(BanBu_RequestCell *)idt
{
   if(!_request)
       return;
    
    
    [_request retoDeleteChange:self];
    
       
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
