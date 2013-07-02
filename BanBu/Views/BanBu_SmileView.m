//
//  BanBu_SmileView.m
//  BanBu
//
//  Created by jie zheng on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_SmileView.h"

#define DeleteTag 999



@implementation BanBu_SmileView

@synthesize type = _type;
@synthesize delegate = _delegate;
@synthesize inputedStr = _inputedStr;
@synthesize typeLay=_typeLay;
@synthesize gifView=_gifView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-40)];
        bkView.image = [UIImage imageNamed:@"chatbg.png"];
        [self addSubview:bkView];
        [bkView release];
        
        UIScrollView *scrool = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 8, 320, 185)];
        scrool.delegate = self;
        scrool.backgroundColor = [UIColor clearColor];
        scrool.contentSize = CGSizeMake(320*1, 180);
        scrool.showsHorizontalScrollIndicator = NO;
        scrool.pagingEnabled = YES;
        _contengView = scrool;
        _contengView.tag=1000;
        [self addSubview:scrool];
        [scrool release];
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 164, 320, 10)];
        pageControl.backgroundColor = [UIColor clearColor];
//        pageControl.numberOfPages = 2;
        pageControl.currentPage = 0;
        _pageControl = pageControl;
        [self addSubview:pageControl];
        [pageControl release];
        
        _type=6;
               
    }
    return self;
}

-(void)setTypeLay:(SmileViewLayoutType)typeLay
{
   if(_typeLay==typeLay)
    {
        return;
    }
    _typeLay=typeLay;
    
       
}

-(void)layoutSubviews
{
    if(_type!=SmileViewAddType)
        
    {
        for(int i=0; i<2; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_em_selected.png"] forState:UIControlStateNormal];
            [button setTitle:i?NSLocalizedString(@"flagTitle", nil):NSLocalizedString(@"smileTitle", nil) forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(typeChange:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(128*i, self.bounds.size.height-40, 128, 40);
            [self addSubview:button];
        }
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(256, self.bounds.size.height-40, 64, 40);
        cancelBtn.tag = DeleteTag;
        [cancelBtn setImage:[UIImage imageNamed:@"btn_em_delete.png"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"btn_em_delete_press.png"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelBtn];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_em_arrow.png"]];
        imageView.frame = CGRectMake(57+128*_pageControl.currentPage, self.bounds.size.height-40, 10, 5);
        [self addSubview:imageView];
        _arrow = imageView;
        [imageView release];
        
        
        _inputedStr = [[NSMutableArray alloc] initWithCapacity:10];
        
    }

}

#pragma UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/320.0;
   
}

//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//-(BOOL)canResignFirstResponder
//{
//    return YES;
//}
- (void)typeChange:(UIButton *)button
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         _arrow.frame = CGRectMake(57+128*button.tag, self.bounds.size.height-40, 10, 5);
                         
                     }
     completion:^(BOOL finished) {
         
         _pageControl.currentPage = 0;
         _contengView.contentOffset = CGPointMake(0, 0);
         self.type = button.tag;
         
     }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchVoiceOrText" object:self];
}


- (void)setType:(SmileViewType)type
{
    if(_type == type)
        return;
    _type = type;
    
    for(UIView *view in _contengView.subviews)
        [view removeFromSuperview];
    
        
    [self layoutIfNeeded];
    
    NSInteger page = 0;
    if(type == SmileViewSmileType)
    {
        _pageControl.numberOfPages = 2;

        _contengView.contentSize= CGSizeMake(320*_pageControl.numberOfPages, 140);
        NSArray  *smileArr = [NSArray arrayWithObjects:@"打怪兽",@"嘟嘟嘴",@"多变",@"饿了",@"高兴",@"歌王",@"好烦啊",@"加油",@"惊讶",@"可爱",@"可怜",@"麦霸",@"怒火",@"饶命",@"撒娇",@"睡觉",@"痛苦",@"羞羞脸",@"阴谋",@"眨眼",@"发大财",@"喷饭",@"炸飞了",@"凄凉",@"T台秀",@"读书",@"扭屁股",@"舞蹈",@"得意",@"运动",@"救命",@"滚远点",@"江南舞",@"走你", nil];
        
        NSArray  * smileLabelArr= [NSArray arrayWithObjects:NSLocalizedString(@"smileItem", nil),NSLocalizedString(@"smileItem1", nil),NSLocalizedString(@"smileItem2", nil),NSLocalizedString(@"smileItem3", nil),NSLocalizedString(@"smileItem4", nil),NSLocalizedString(@"smileItem5", nil),NSLocalizedString(@"smileItem6", nil),NSLocalizedString(@"smileItem7", nil),NSLocalizedString(@"smileItem8", nil),NSLocalizedString(@"smileItem9", nil),NSLocalizedString(@"smileItem10", nil),NSLocalizedString(@"smileItem12", nil),NSLocalizedString(@"smileItem13", nil),NSLocalizedString(@"smileItem15", nil),NSLocalizedString(@"smileItem16", nil),NSLocalizedString(@"smileItem17", nil),NSLocalizedString(@"smileItem19", nil),NSLocalizedString(@"smileItem20", nil),NSLocalizedString(@"smileItem22", nil),NSLocalizedString(@"smileItem23", nil),NSLocalizedString(@"smileItem24", nil),NSLocalizedString(@"smileItem25", nil),NSLocalizedString(@"smileItem26", nil),NSLocalizedString(@"smileItem27", nil),NSLocalizedString(@"smileItem28", nil),NSLocalizedString(@"smileItem29", nil),NSLocalizedString(@"smileItem30", nil),NSLocalizedString(@"smileItem31", nil),NSLocalizedString(@"smileItem32", nil),NSLocalizedString(@"smileItem33", nil),NSLocalizedString(@"smileItem34", nil),NSLocalizedString(@"smileItem35", nil),NSLocalizedString(@"smileItem36", nil),NSLocalizedString(@"smileItem37", nil), nil];
        
        
        for(int i=0; i<[smileArr count]; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"%@",[smileArr objectAtIndex:i]];
            
            
            
            NSString *path=[[NSBundle mainBundle]pathForResource:imageName ofType:@"gif"];
            
            SCGIFImageView *gif=[[SCGIFImageView alloc]initWithGIFFile:path];
//            UIImageView *gif = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",imageName]]];
            gif.userInteractionEnabled=YES;
            
            gif.frame=CGRectMake(320*page+10+52*(i%6), 50*(i/6-3*page), 35, 35);
            
            gif.backgroundColor=[UIColor blackColor];
            
            gif.tag=i;
            
            
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(320*page+5+52*(i%6), 50*(i/6-3*page)+35,47 ,15)];
            
            nameLabel.userInteractionEnabled=YES;
            
            nameLabel.backgroundColor=[UIColor clearColor];
            
            nameLabel.text=[smileLabelArr objectAtIndex:i];
            
            nameLabel.textAlignment=NSTextAlignmentCenter;
            
            nameLabel.textColor=[UIColor darkGrayColor];
            
            nameLabel.font=[UIFont systemFontOfSize:10];
            
            [_contengView addSubview:nameLabel];
            
            [nameLabel release];
            
            //加一个手势 让他触发方法
            
            UITapGestureRecognizer *tapGester=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnPress:)];
            
            [gif addGestureRecognizer:tapGester];
            
    
            [tapGester release];
            
            [_contengView addSubview:gif];
            

            [gif release];
            
            if(i>16 && !page)
                page = 1;
            if(i>34){
                page = 2;
            }
 
        }
        
    }
    else if(type==SmileViewCharactersPaintedType)
    {
        
        _contengView.contentSize= CGSizeMake(320*3, 140);
        _pageControl.numberOfPages = 3;

        
        NSArray *titles = [NSArray arrayWithObjects:@"T_T",@"⊙ ⊙",@"~~>_<~~",@"^_~",@"*o*",@":p",@"@_@",@"<@_@>",@"o_o",@"^o^",@"O_O",@"-_-",@"^_^",@"＿.,＿",@"^v^",@"^^v",@"(^-^)",@"=_=^",@"=^_^=",@"*^_^*",@"=_=",@"+_+",@"?_?",@"$_$",@"~_~",@"T^T",@">o<",@"e_e",@"－_－#",@"－_－b",@"－_－^",@">_<",@"－O－",@"O(∩_∩)O~",@"(*^__^*)",@"\(^o^)/~",@"( ⊙o⊙ )",@"╭(╯^╰)╮",@"（¯『¯）",@"o(≥v≤)o~~",@"~(@^_^@)~",@"(^ω^)",@"(*^◎^*)",@"(+﹏+)~",@"o(╯□╰)o",@"╭∩╮",@"-_-|||",@"( ^_^ )/~~",@"(ˉ(∞)ˉ)" ,nil];
        for(int i=0; i<48; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(320*page+80*(i%4),34*(i/4-4*page), 79,33);
            [button setBackgroundImage:[UIImage imageNamed:@"button_emotion.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [_contengView addSubview:button];
            if(i>14 && !page)
                page = 1;
            if(i>30){
                page = 2;
            }
        }
    }else
    {
       
        
//        for(UIView *view in _contengView.subviews)
//            [view removeFromSuperview];
        
        _contengView.contentSize= CGSizeMake(320*1, 140);
        _pageControl.numberOfPages = 1;

        NSMutableArray *nameArr=[[NSMutableArray alloc]initWithObjects:@"拍照",@"相册",@"破冰语",@"涂鸦",@"位置", nil];
        
       
       
        NSMutableArray *labelArr=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"funLabel", nil),NSLocalizedString(@"funLabel1", nil),NSLocalizedString(@"searchIce", nil),NSLocalizedString(@"funLabel3", nil),NSLocalizedString(@"locationBtn", nil), nil];
        
        if(_delegate&&[_delegate respondsToSelector:@selector(addActionCard)])
        {
            
            NSString *name=[_delegate addActionCard];
            
            [nameArr addObject:name];
            
        }
        
        NSInteger page=0;
        for(int i=0;i<[nameArr count];i++){
            
            NSString *imageName = [NSString stringWithFormat:@"%@.png",[nameArr objectAtIndex:i]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(320*page+32+100*(i%3), 87*(i/3-2*page), 55, 55);
            
            [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(actionToadd:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [_contengView addSubview:button];
            
            UILabel *label=[[UILabel alloc]init];
            
            label.frame=CGRectMake(320*page+15+100*(i%3), 87*(i/3-2*page)+60, 85, 15);
            
            label.textAlignment=NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor=[UIColor clearColor];
            
              NSString *str= [labelArr objectAtIndex:i];
            
             label.text=str;
            
            [_contengView addSubview:label];
            
            [label release];
            
            if(i>8 && !page)
                page = 1;
            
            
        }

        
        
        
        
    }
}


-(void)btnPress:(UITapGestureRecognizer *)tap
{
    NSString *inputStr=nil;
    
    NSArray  *smileArr = [NSArray arrayWithObjects:@"打怪兽",@"嘟嘟嘴",@"多变",@"饿了",@"高兴",@"歌王",@"好烦啊",@"加油",@"惊讶",@"可爱",@"可怜",@"麦霸",@"怒火",@"饶命",@"撒娇",@"睡觉",@"痛苦",@"羞羞脸",@"阴谋",@"眨眼",@"发大财",@"喷饭",@"炸飞了",@"凄凉",@"T台秀",@"读书",@"扭屁股",@"舞蹈",@"得意",@"运动",@"救命",@"滚远点",@"江南舞",@"走你", nil];
    inputStr=[smileArr objectAtIndex:tap.view.tag];
    
    NSLog(@"the gap is is is is isi is is isi is is is %@",inputStr);
    
    if([_delegate respondsToSelector:@selector(banBu_SmileView:didInputSmile:isDelete:type:)])
        [_delegate banBu_SmileView:self didInputSmile:inputStr isDelete:NO type:1];
    
    

}

- (void)btnPressed:(UIButton *)button
{
    if(button.tag == DeleteTag)
    {
        if([_delegate respondsToSelector:@selector(banBu_SmileView:didInputSmile:isDelete:type:)])
            [_delegate banBu_SmileView:self didInputSmile:nil isDelete:YES type:0];
    }
    else 
    {
        NSString *inputStr = nil;
        if(_type == SmileViewCharactersPaintedType)
        {    inputStr = button.titleLabel.text;
        
            [_inputedStr addObject:inputStr];
            
            
            if([_delegate respondsToSelector:@selector(banBu_SmileView:didInputSmile:isDelete:type:)])
                [_delegate banBu_SmileView:self didInputSmile:inputStr isDelete:NO type:0];

            
            
        }
        else
        {

            NSString *smileStr = @"[吃包子]|[打怪兽]|[大跌眼镜]|[高歌一曲]|[歌舞王后]|[加油]|[泪流满面]|[路过]|[怒发冲冠]|[俏皮]|[求包养]|[求饶]|[睡觉]|[太帅了]|[头都大了]|[兴高采烈]|[羞羞脸]|[压力好大]|[阴谋得逞]|[睁大眼睛]|[装可爱]";

            inputStr = [NSString stringWithFormat:@"%@",[[smileStr componentsSeparatedByString:@"|"] objectAtIndex:button.tag]];
            
            [_inputedStr addObject:inputStr];
            if([_delegate respondsToSelector:@selector(banBu_SmileView:didInputSmile:isDelete:type:)])
                [_delegate banBu_SmileView:self didInputSmile:inputStr isDelete:NO type:1];
            
            
        }
                
    }
    
}

-(void)actionToadd:(UIButton *)bt
{
 
    if(_delegate&&[_delegate respondsToSelector:@selector(banBu_ActionView:didInputBrand:isAdd:)])
    {
         if(bt.tag==0)
         {
           
             [_delegate banBu_ActionView:self didInputBrand:bt isAdd:YES];
         
         }else
         {
               
             [_delegate banBu_ActionView:self didInputBrand:bt isAdd:NO];
         
         }     
    
    }
    

}
- (void)dealloc
{
    self.delegate = nil;
    self.inputedStr = nil;
    [super dealloc];
}

@end
