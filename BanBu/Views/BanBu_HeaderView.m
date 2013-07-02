//
//  BanBu_HeaderView.m
//  BanBu
//
//  Created by apple on 12-12-21.
//
//

#import "BanBu_HeaderView.h"
#import <QuartzCore/QuartzCore.h>
#define x 80
@interface BanBu_HeaderView()

-(void)initEvery;

@end



@implementation BanBu_HeaderView
@synthesize headImage=_headImage,nameAndsex=_nameAndsex,starLabel=_starLabel,nameLabel=_nameLabel,nextButton=_nextButton,nextView=_nextView,chat=_chat,ageLabel=_ageLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

-(BanBu_HeaderView *)initWithDelegate:(BanBu_ChatViewController *)table Selector:(SEL)nextView Frame:(CGRect)rect TableView:(UITableView *)tablet
{
    self=[super init];
    
    if(self)
    {
        self.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
      
        self.chat=table;
        
        self.frame=rect;
        
        _nextView=nextView;
        
        [self initEvery];
    
        // 加一个点击的手势
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushNext:)];
        
        tap.numberOfTapsRequired=1;
        
        [self addGestureRecognizer:tap];
        
        [tap release];
        
        
        
        
        return self;
        
    }

    return nil;


}

-(void)pushNext:(UITapGestureRecognizer *)tap
{
    if(_nextView)
    {
    [_chat performSelector:_nextView];

    }

}
-(void)initEvery
{

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 54, 54)];
    
    _headImage = imageView;
    _headImage.contentMode = UIViewContentModeScaleAspectFit;
    _headImage.layer.borderWidth = 1.0f;
    _headImage.layer.borderColor = [[UIColor lightTextColor] CGColor];
//    _headImage.backgroundColor=[UIColor redColor];
    
    [self addSubview:_headImage];
    
    [imageView release];


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(63,5, 235, 25)];
    _nameLabel = label;
    _nameLabel.textAlignment = UITextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_nameLabel];
    [label release];
    
    _nameAndsex = [[UILabel alloc]init];
    _nameAndsex.frame = CGRectMake(63, 35, 25, 25);
    _nameAndsex.backgroundColor=[UIColor clearColor];
    
    _nameAndsex.font = [UIFont systemFontOfSize:13];
//    [_nameAndsex setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_nameAndsex setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 10)];
    
    _nameAndsex.textColor=[UIColor whiteColor];
    
    [self addSubview:_nameAndsex];
    

    _starLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,35, 75, 25)];
    _starLabel.backgroundColor=[UIColor clearColor];
    
    _starLabel.textAlignment=NSTextAlignmentCenter;
    
    _starLabel.font = [UIFont systemFontOfSize:13];
    _starLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_starLabel];
    [_starLabel release];
    
    
    // 右边的小箭头
    
    _nextButton=[UIButton buttonWithType: UIButtonTypeCustom];
    
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"profileios.png"] forState:UIControlStateNormal];
    
    [_nextButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextButton.frame=CGRectMake(300, 25, 10, 16);
    
    [self addSubview:_nextButton];
    
    // 年龄的label
    _ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(175, 35, 50, 25)];
    
    _ageLabel.backgroundColor=[UIColor clearColor];
    
    _ageLabel.font=[UIFont systemFontOfSize:13];
    
    _ageLabel.textAlignment=NSTextAlignmentLeft;
    
    _ageLabel.textColor=[UIColor blackColor];
    
    [self addSubview:_ageLabel];
    
    [_ageLabel release];
    
    
    // uilabel
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, 320, 1)];
    
    lineLabel.backgroundColor=[UIColor grayColor];
    
    lineLabel.alpha=.1;
    
    [self addSubview:lineLabel];
    
    [lineLabel release];
    
    
    
    

}
-(void)setHeadImaget:(NSString *)headImage
{

     [_headImage setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];

}

-(void)setNameLabelt:(NSString *)name
{

    _nameLabel.text=name;

}

-(void)setGender:(NSString *)sex
{
   if([sex isEqual:@"m"])
   {
       [_nameAndsex setBackgroundColor:[UIColor colorWithRed:103.0/255 green:187.0/255 blue:1.0 alpha:1.0]];
       
       _nameAndsex.text=@"  ♂ ";
       
       _nameAndsex.layer.cornerRadius=4.0;

   }else
   {
   
       
       [_nameAndsex setBackgroundColor:[UIColor colorWithRed:253.0/255 green:163.0/255 blue:200.0 alpha:1.0]];
       
       _nameAndsex.text=@"  ♀ ";
       // [_nameAndsex setTitle:@" ♀ " forState:UIControlStateNormal];
       
       _nameAndsex.layer.cornerRadius=4.0;

   }
}


-(void)setAgeAndSext:(NSString *)ageAndsex
{
    NSLog(@"0 0 0 0 0++++%d",[ageAndsex intValue]);
    if([ageAndsex intValue]!=0)
    {
//        [_nameAndsex setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
//        [_nameAndsex setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateHighlighted];
        
        [_nameAndsex setBackgroundColor:[UIColor colorWithRed:103.0/255 green:187.0/255 blue:1.0 alpha:1.0]];
        
         _nameAndsex.text=@"  ♂ ";
       
        _nameAndsex.layer.cornerRadius=4.0;
        
    }
    
    else
    {
//        [_nameAndsex setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateNormal];
//        [_nameAndsex setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateHighlighted];
       
        [_nameAndsex setBackgroundColor:[UIColor colorWithRed:253.0/255 green:163.0/255 blue:200.0 alpha:1.0]];
        
        _nameAndsex.text=@"  ♀ ";
       // [_nameAndsex setTitle:@" ♀ " forState:UIControlStateNormal];
        
        _nameAndsex.layer.cornerRadius=4.0;
        
        
        
    }
    

}

-(void)setStar:(NSString *)star
{
    _starLabel.text=star;

}

-(void)setAge:(NSString *)age
{
    
    _ageLabel.text=age;


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
