//
//  BanBu_MessageOptionCell.m
//  BanBu
//
//  Created by apple on 13-3-5.
//
//

#import "BanBu_MessageOptionCell.h"
#define CellRelease(_v) [_v release],_v=nil
@implementation BanBu_MessageOptionCell
@synthesize messageLabel=_messageLabel;
@synthesize imageViewt=_imageViewt;
@synthesize flag=_flag;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILabel *message=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 50)];
        
        _messageLabel=[message retain];
        
        _messageLabel.backgroundColor=[UIColor clearColor];
        
        //_messageLabel.font=[UIFont systemFontOfSize:22];
        
        _messageLabel.font=[UIFont boldSystemFontOfSize:18];
        
        [self addSubview:_messageLabel];
        
        
        [_messageLabel release];
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(250, 30, 25, 25)];
        
        
        self.imageViewt=imageV;
        
        
        _imageViewt.userInteractionEnabled=YES;
     
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMake:)];
        
        [_imageViewt addGestureRecognizer:tap];
        
        [tap release];
        
        
        [self addSubview:_imageViewt];
        
        [_imageViewt release];
        
        
  
        
    }
    return self;
}

-(void)toMake:(UITapGestureRecognizer *)tap
{

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"haha" object:self userInfo:nil];

    
    

}



-(void)setFlag:(BOOL)flag
{
      _flag=flag;
    
    if(_flag)
    {
    
        _imageViewt.image=[UIImage imageNamed:@"复选框_选中.png"];
        
    }else
    {
    
        _imageViewt.image=[UIImage imageNamed:@"复选框.png"];
        
        
    }


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
   

}

-(void)setString:(NSString *)stringt
{   
    _messageLabel.text=stringt;


}

-(void)dealloc
{
    
    CellRelease(_imageViewt);
    
    CellRelease(_messageLabel);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super dealloc];
}
@end
