//
//  BanBu_SmileLabel.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_SmileLabel.h"

#define DefaultFont [UIFont systemFontOfSize:17]
#define Marge 15
#define MaxWidth 160
#define PicWidth 24
#define DefaultHeight [@"f" sizeWithFont:DefaultFont].height
#define LineSep DefaultHeight+2.0
#define PicSep DefaultHeight+8.0
#define SmileStr  @"[装可爱]|[睁大眼睛]|[阴谋得逞]|[压力好大]|[兴高采烈]|[太帅了]|[睡觉]|[求饶]|[求包养]|[俏皮]|[怒发冲冠]|[目瞪口呆]|[路过]|[泪流满面]|[可怜兮兮]|[害羞]|[歌舞王后]|[高歌一曲]|[发奋图强]|[嘟嘟嘴]|[大跌眼镜]|[打怪兽]|[吃包子]|[不同意]"



@implementation BanBu_SmileLabel

@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}

+ (float)heightForText:(NSString *)text
{
    NSArray *smiles = [SmileStr componentsSeparatedByString:@"|"];
    for(NSString *aSmile in smiles)
    {
        text = [text stringByReplacingOccurrencesOfString:aSmile withString:@"ww"];
        
    }
    
    CGSize size = [text sizeWithFont:DefaultFont constrainedToSize:CGSizeMake(MaxWidth-20, 1000) lineBreakMode:UILineBreakModeWordWrap];
//    NSLog(@"--------%f",size.height);

    return size.height+((size.height>20)?20:0);
}


- (void)setText:(NSString *)text
{
    [_text release];
    _text = [text retain];
    
    NSString *newText = [NSString stringWithFormat:@"%@",_text];
    NSArray *smiles = [SmileStr componentsSeparatedByString:@"|"];
    for(NSString *aSmile in smiles)
    {
        newText = [newText stringByReplacingOccurrencesOfString:aSmile withString:@"ww"];
        
    }
    
    CGSize size = [newText sizeWithFont:DefaultFont constrainedToSize:CGSizeMake(MaxWidth-2*Marge, 1000)lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = self.frame;
    newFrame.size.height = size.height + Marge*2;
    NSLog(@"%f",newFrame.size.height);
    newFrame.size.width = (size.height>DefaultHeight)?MaxWidth:(size.width + 2*Marge);
   
    self.frame = newFrame;
    
    [self setNeedsDisplay];

    

}
/*
- (void)layoutSubviews
{

    UILabel *lable=[[UILabel alloc]initWithFrame:self.bounds];
    
    lable.backgroundColor=[UIColor clearColor];
    
    
    lable.text=_text;
    
    lable.textColor=[UIColor blackColor];
    
    lable.numberOfLines=0;
    
    lable.lineBreakMode = UILineBreakModeWordWrap;
    
    lable.textAlignment=NSTextAlignmentLeft;
    
    [self addSubview:lable];
    
    [lable release];


}
*/
- (void)drawRect:(CGRect)rect
{
    //[:91  ]:93 
    float x = Marge;
    float y = Marge;
    //BOOL havePicInLine = NO;
    NSArray *smiles = [SmileStr componentsSeparatedByString:@"|"];

    for(int i=0; i<_text.length; i++)
    {
        NSString *character = [_text substringWithRange:NSMakeRange(i, 1)];
       if([character characterAtIndex:0] == 91)
       {
           int j = i;
           while (j<_text.length+1) {
               
               j++;
               if([_text characterAtIndex:j] == 93)
               {
                   j++;
                   break;
               }
           }
           
           if(j < _text.length+1)
           {
               
               NSString *smileStr = [_text substringWithRange:NSMakeRange(i, j-i)];
               NSInteger index = [smiles indexOfObject:smileStr];
               if(index != NSNotFound)
               {

                   NSString *picName = [NSString stringWithFormat:@"em%i.jpg",index+1];
                   UIImage *image = [UIImage imageNamed:picName];
                   if(MaxWidth-x-PicWidth > Marge/2)
                   {
                       [image drawInRect:CGRectMake(x,y-(PicWidth-DefaultHeight)/2, PicWidth, PicWidth)];
                       x += PicWidth;
                   }
                   else 
                   {
                       x = Marge;
                       y += LineSep;
                       [image drawInRect:CGRectMake(x,y-(PicWidth-DefaultHeight)/2, PicWidth, PicWidth)];
                       x += PicWidth;
                   }
                   i = j-1;
                   continue;
               }
           }
       }
       
       CGFloat width = [character drawAtPoint:CGPointMake(x, y) forWidth:175 withFont:DefaultFont fontSize:18 lineBreakMode:UILineBreakModeWordWrap baselineAdjustment:UIBaselineAdjustmentAlignCenters].width;
    
        x += width;
        if(MaxWidth-x < Marge+10)
        {
            y += LineSep;
            x = Marge;
        }
        
    }
}

/*
- (void)drawRectt:(CGRect)rect
{
    UILabel *lable=[[UILabel alloc]initWithFrame:self.bounds];

    lable.backgroundColor=[UIColor clearColor];
    
    
    lable.text=_text;
    
    lable.textColor=[UIColor blackColor];
    
    lable.numberOfLines=0;
    
    lable.lineBreakMode = UILineBreakModeWordWrap;
    
    lable.textAlignment=NSTextAlignmentCenter;
    
    [self addSubview:lable];
    
    [lable release];


}
*/
- (void)dealloc
{
    [_text release];
    [super dealloc];
}

@end
