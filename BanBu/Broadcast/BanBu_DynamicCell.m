//
//  BanBu_DynamicCell.m
//  BanBu
//
//  Created by apple on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_DynamicCell.h"
#import "SDWebImageManager.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "UIBadgeView.h"
@implementation BanBu_DynamicCell
 float picHeigh;


@synthesize
descriptionString=_descriptionString,picString=_picString,sexbtnString=_sexbtnString,zhuanfabtnString=_zhuanfabtnString,commitbtnString=_commitbtnString,timeString=_timeString,delegate=_delegate,nameLabel=nameLabel,timeLabel = _timeLabel,headImage=headImage,gender=_gender,age=_age,picArr = _picArr,type = _type;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initRay];
        _picArr = [[NSMutableArray alloc]initWithCapacity:10];
//        SDWebImageManager *aSd =[SDWebImageManager sharedManager];
//        aSd.obsever = self;
    }
    return self;
}

-(void)goToInfo{
    
    if([_delegate respondsToSelector:@selector(information)]){
        
        [_delegate performSelector:@selector(information)];
    }
}

-(void)initRay
{
   // 初始化头像的位置
    
    headImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];

    headImage.backgroundColor=[UIColor clearColor];

    headImage.userInteractionEnabled = YES;
    
    [self addSubview:headImage];
    
    [headImage release];

   

  // 初始化名字的label 的位置
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 3, 150, 20)];
    
    nameLabel.backgroundColor=[UIColor clearColor];
    
    nameLabel.textAlignment=UITextAlignmentLeft;
    
    nameLabel.font=[UIFont systemFontOfSize:15];
    
//    nameLabel.textColor=[UIColor darkGrayColor];
    
    [self addSubview:nameLabel];
    
    [nameLabel release];
    // 初始化 发表言论的label 的位置 
    
    descriptionLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    
    descriptionLabel.numberOfLines=0;
    
    descriptionLabel.backgroundColor=[UIColor clearColor];
    
    descriptionLabel.textAlignment=UITextAlignmentLeft;
    
    descriptionLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:descriptionLabel];
    
    [descriptionLabel release];
    
    [self addObserver:self forKeyPath:@"descriptionString" options:NSKeyValueObservingOptionNew context:nil];
    
    // 初始化图片的位置 
    
   
    // 对评论 和 转发的加以监听
    
    
    [self addObserver:self forKeyPath:@"commitbtnString" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    [self addObserver:self forKeyPath:@"zhuanfabtnString" options:NSKeyValueObservingOptionNew context:nil];

    
    
    [self addObserver:self forKeyPath:@"picArr" options:NSKeyValueObservingOptionNew context:nil];
    
        
    // 初始化性别和年龄的button 
    
    sexBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    sexBtn.frame=CGRectZero;
    
    [self addSubview:sexBtn];
    
    [self addObserver:self forKeyPath:@"sexbtnString" options:NSKeyValueObservingOptionNew context:nil];
    
    // 初始化回复时间的label 
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    
    _timeLabel.backgroundColor=[UIColor clearColor];
    
    _timeLabel.textAlignment=UITextAlignmentLeft;
    
    _timeLabel.font=[UIFont systemFontOfSize:15];
    
    _timeLabel.textColor=[UIColor darkGrayColor];
    
    [self addSubview:_timeLabel];
    
    
    [self addObserver:self forKeyPath:@"timeString" options:NSKeyValueObservingOptionNew context:nil];
    
  // 初始化 背景图片的位置 
    
    backGround=[[UIImageView alloc]initWithFrame:CGRectZero];
    
    [self addSubview:backGround];
    
    [self sendSubviewToBack:backGround];
    
    [backGround release];

}

- (void)setAvatar:(NSString *)avatarUrlStr
{
    [headImage setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:0];
}

- (UIImage *)scaleImage:(UIImage *)image proportion:(float)scale {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width/scale, image.size.height/scale));
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width/scale, image.size.height/scale);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*
-(void)sdImageManagerDidLoadImageWithUrl:(NSURL *)url forImageView:(UIImageView *)imageView image:(UIImage *)image fromLocal:(BOOL)loadFromLocal{
    
    if(imageView.tag ==1 || imageView.tag ==2){
        imageView.image = [self scaleImage:imageView.image proportion:4];
        imageView.frame =CGRectMake(87,imageView.frame.origin.y, imageView.image.size.width, imageView.image.size.height);
        picHeigh += imageView.frame.size.height+5;
        
        
        
        float nameHeigh=nameLabel.frame.size.height;
        float descriHeigh=descriptionLabel.frame.size.height;
        float pinglunHeigh = commitBtn.frame.size.height;
        
        CGRect selfFrame=self.frame;
        selfFrame.size.width=320;
        selfFrame.size.height=nameHeigh+picHeigh+descriHeigh+pinglunHeigh+30;
        
        if(selfFrame.size.height >116){
            CGFloat height = selfFrame.size.height;
            selfFrame.size.height = height - 35;
        }else{
            selfFrame.size.height = 81;
        }
        
        self.frame=selfFrame;
        commitBtn.frame=CGRectMake(209, selfFrame.size.height-15, 60, 20);
        zhuanfaBtn.frame=CGRectMake(274, selfFrame.size.height-15, 40, 20);
        
        
        backGround.frame=CGRectMake(0, 0, 320, selfFrame.size.height+10);
        UIImage *tempImage=[UIImage imageNamed:@"listbg.png"];
        
        backGround.image=[tempImage stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
    }
    
    
    
}
*/

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"%@%@",object,context);
    
    // 转发 文本的label 的大小
    if([keyPath isEqualToString: @"descriptionString"])
    {
        picHeigh = 0;

        descriptionLabel.text=_descriptionString;
        descriptionLabel.textColor = [UIColor darkGrayColor];
        descriptionLabel.backgroundColor = [UIColor clearColor];
//        //NSLog(@"%@",descriptionLabel.text);
        descriptionLabel.font=[UIFont systemFontOfSize:15];
        CGSize descriptionSize=[descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:UILineBreakModeWordWrap];
//        if(descriptionSize.height<40){
//            descriptionSize.height =35;
//        }
        descriptionLabel.frame=CGRectMake(65, 38, 240, descriptionSize.height);
        [self addSubview:descriptionLabel];
      
      // 图片的大小和位置
    }
    else if([keyPath isEqualToString:@"picArr" ])
    {   
        for(int i=1;i<=[_picArr count];i++){
            UIImageView *postPic=[[UIImageView alloc]initWithFrame:CGRectMake(65, picHeigh+descriptionLabel.frame.size.height+50, 162, 109)];
            postPic.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            postPic.layer.borderWidth = 1.0;
            postPic.userInteractionEnabled=YES;
            postPic.tag = i*10;
            postPic.backgroundColor=[UIColor blueColor];
//            postPic.layer.borderColor = [[UIColor redColor]CGColor];
//            postPic.layer.borderWidth = 10;
            [postPic setImageWithURL:[NSURL URLWithString:[_picArr objectAtIndex:i-1]] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:0];
            
            if(MyAppDataManager.k<1){
                [AppComManager  getBanBuMedia:[_picArr objectAtIndex:i-1] delegate:_delegate];
                MyAppDataManager.k++;
            }
            postPic.image = [MyAppDataManager imageForImageUrlStr:[_picArr objectAtIndex:i-1]];

            postPic.image = [self scaleImage:postPic.image proportion:4];
         
            postPic.frame =CGRectMake(65,postPic.frame.origin.y, postPic.image.size.width, postPic.image.size.height);

            picHeigh += postPic.frame.size.height+10;

            [self addSubview:postPic];
            [postPic release];
            /*if(postPic.tag == 10){
                
                //语音
                UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [voiceBtn setTitle:@"语音" forState:UIControlStateNormal];
                voiceBtn.frame = CGRectMake(60+postPic.frame.size.width-10, postPic.frame.origin.y+10, 30, 30);
                [voiceBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:voiceBtn];
                
            }*/
                      
            UITapGestureRecognizer *gest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [[self viewWithTag:i*10] addGestureRecognizer:gest];
            [gest release];
            //NSLog(@"%f",picHeigh);

        }
  
    }
    else if([keyPath isEqualToString:@"sexbtnString"])
    {
    
        sexBtn.frame=CGRectMake(65, 40, 28, 14);
    
        CGRect rect=descriptionLabel.frame;
        
        rect.origin.x=120;
    
        descriptionLabel.frame=rect; 
        // 看看是不是女的还是男的
        
        [sexBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 10)];
        
        sexBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        
        
        if([_sexbtnString isEqualToString:@"m"])
        {
            [sexBtn setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
            [sexBtn setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateHighlighted];
            [sexBtn setTitle:[NSString stringWithFormat:@"%@",_age] forState:UIControlStateNormal];       
        }else {
            [sexBtn setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateNormal];
            [sexBtn setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateHighlighted];
            [sexBtn setTitle:[NSString stringWithFormat:@"%@",_age] forState:UIControlStateNormal];
        }   
        
        
        
       // sexBtn.backgroundColor=[UIColor redColor];
        
        // 监听 有没有一个属性值是time的
    }
    else if([keyPath isEqualToString:@"timeString" ])
    {
 

        _timeLabel.frame=CGRectMake(65, 8, 140, 20);
        _timeLabel.text=_timeString;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.backgroundColor = [UIColor clearColor];
    
    
    }
    else if([keyPath isEqualToString:@"commitbtnString"])
    {
        
        // 初始化评论的label
        
        commitBtn=[[UIView alloc]initWithFrame:CGRectZero];;
        commitBtn.tag = 1;
        commitBtn.frame=CGRectMake(55, 40, 70, 25);
//        [commitBtn setTitle:_commitbtnString forState:UIControlStateNormal];
//        [commitBtn addTarget:self action:@selector(function:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [commitBtn setBackgroundColor:[UIColor clearColor]];
        
//        [commitBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [commitBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [self addSubview:commitBtn];
        
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pinglunAction)];
        [commitBtn addGestureRecognizer:aTap];
        [aTap release];
        
        
        UIImageView *pinglunView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        pinglunView.image = [UIImage imageNamed:@"dongtai.png"];
        pinglunView.userInteractionEnabled = YES;
        [commitBtn addSubview:pinglunView];
        [pinglunView release];
        UIBadgeView * aBadgeView = [[UIBadgeView alloc]initWithFrame:CGRectZero];
        aBadgeView.backgroundColor = [UIColor clearColor];
        aBadgeView.badgeColor = [UIColor redColor];
        float width = [_commitbtnString sizeWithFont:[UIFont boldSystemFontOfSize:14]].width+12;

        aBadgeView.frame = CGRectMake(15, -3, width, 20);
        
        aBadgeView.badgeString = _commitbtnString;
        [commitBtn addSubview:aBadgeView];
        [aBadgeView release];
        
        
    }
    else if([keyPath isEqualToString:@"zhuanfabtnString"])
    {
        
        // 初始化转发的button
        
        //        //NSLog(@"%@",[change objectForKey:@"new"]);
      
        zhuanfaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        zhuanfaBtn.tag = 2;
        zhuanfaBtn.frame=CGRectMake(244, 40, 70, 25);

        [zhuanfaBtn addTarget:self action:@selector(function:) forControlEvents:UIControlEventTouchUpInside];
        //截图字符串方法一
//        [zhuanfaBtn setTitle:[_zhuanfabtnString substringWithRange:NSMakeRange(0,[_zhuanfabtnString rangeOfString:@"-"].location)] forState:UIControlStateNormal];
//        _selctedRow = [[_zhuanfabtnString substringWithRange:NSMakeRange([_zhuanfabtnString rangeOfString:@"-"].location+1,_zhuanfabtnString.length-1-[_zhuanfabtnString rangeOfString:@"-"].location)] integerValue];
        //方法二
        NSArray *arr = [NSArray array];
        arr = [_zhuanfabtnString componentsSeparatedByString:@"-"];
        [zhuanfaBtn setTitle:[arr objectAtIndex:0] forState:UIControlStateNormal];
        _selctedRow = [[arr objectAtIndex:1] integerValue];
        
//        NSLog(@"%@",arr);
    
        [zhuanfaBtn setBackgroundColor:[UIColor clearColor]];
        
        [zhuanfaBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [zhuanfaBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

        zhuanfaBtn.titleLabel.font=[UIFont systemFontOfSize:13];
              
        [self addSubview:zhuanfaBtn];


        
        jubaoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        jubaoView.tag = _selctedRow;
        jubaoView.image = [UIImage imageNamed:@"reportBtn.png"];
        [zhuanfaBtn addSubview:jubaoView];
        [jubaoView release];
//        NSLog(@"%d",jubaoView.tag);
        
    }

//    float nameHeigh=nameLabel.frame.size.height;
    float timeheigh = _timeLabel.frame.size.height + 8;
    float descriHeigh=descriptionLabel.frame.size.height+10;
    float pinglunHeigh = (_type==DynamicMe)?commitBtn.frame.size.height:zhuanfaBtn.frame.size.height;
    
    CGRect selfFrame=self.frame;
    selfFrame.size.width=320;
    selfFrame.size.height= timeheigh + picHeigh+descriHeigh+pinglunHeigh+10;
    
//    if(selfFrame.size.height >116){
//        CGFloat height = selfFrame.size.height;
//        selfFrame.size.height = height - 35;
//    }else{
//        selfFrame.size.height = 81;
//    }
    
    self.frame=selfFrame;
    commitBtn.frame=CGRectMake(57, selfFrame.size.height-25, 40, 25);
    zhuanfaBtn.frame=CGRectMake(300-[_zhuanfabtnString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(120, 20)].width, selfFrame.size.height-25, [_zhuanfabtnString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(120, 20)].width+10, 25);

    
    if(_type == DynamicMe){
        backGround.frame=CGRectMake(0, 0, 320, selfFrame.size.height+10);
        UIImage *tempImage=[UIImage imageNamed:@"listbg.png"];
        backGround.image=[tempImage stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
        UITapGestureRecognizer *aHeadImgeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToInfo)];
        [headImage addGestureRecognizer:aHeadImgeTap];
        [aHeadImgeTap release];
    }else{
        _timeLabel.frame=CGRectMake(65, selfFrame.size.height-22, 140, 20);

        backGround.frame=CGRectMake(0, selfFrame.size.height+10, 320, 1);
        backGround.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    }
   
    
    
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"descriptionString"];
 
    [self removeObserver:self forKeyPath:@"picArr"];
    
    [self removeObserver:self forKeyPath:@"commitbtnString"];
    
    [self removeObserver:self forKeyPath:@"zhuanfabtnString"];
    
    [self removeObserver:self forKeyPath:@"sexbtnString"];
    
    [self removeObserver:self forKeyPath:@"timeString"];

    [_picArr release];
    [super dealloc];
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// 点击图片 放大图片 

-(void)tap:(UITapGestureRecognizer *)sender
{
    
    
   if([_delegate respondsToSelector:@selector(pushTobigPic:)])
   {
   
       [_delegate performSelector:@selector(pushTobigPic:) withObject:[NSNumber numberWithInt:sender.view.tag]];
   
   
   }
//      NSLog(@"%d",sender.view.tag);
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"labelText" object:[NSNumber numberWithInteger:sender.view.tag]];

    
    
}

// 点击转发 进行转发
// delegate de version 

-(void)pinglunAction{
    if([_delegate respondsToSelector:@selector(pushNextViewController)])
    {
        
        
        [_delegate performSelector:@selector(pushNextViewController)];
        
        
    }
}


-(void)function:(UIButton *)sender
{
    if(sender.tag ==1){
        if([_delegate respondsToSelector:@selector(pushNextViewController)])
        {
            
            
            [_delegate performSelector:@selector(pushNextViewController)];
            
            
        }
       
    }else if(sender.tag == 2){
        if([_delegate respondsToSelector:@selector(transFormtheNew:)])
        {
     
            [_delegate transFormtheNew:jubaoView.tag];
            
            
        }
    }
   


}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



@end
