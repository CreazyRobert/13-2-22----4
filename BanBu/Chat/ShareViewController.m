//
//  ShareViewController.m
//  微信小助手
//
//  Created by Away on 13-4-16.
//  Copyright (c) 2013年 Jc Zhang. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithURLString:(NSString *)_url
{
    self = [super init];
    if(self)
    {
        if(_url){
            urlString = [[NSString alloc] initWithString:_url];

        }else{
            urlString = @"";
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"分享";
    self.view.backgroundColor = [UIColor clearColor];
    for(int i=0;i<7;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"s%d.png",i+1]];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"s%d.png",i+1]] forState:UIControlStateNormal];
//        NSLog(@"%@",[NSString stringWithFormat:@"s%d.png",i+1]);
        btn.tag = (i+1)*11;
        btn.frame = CGRectMake(i*75+20, 50, 55, 55);
        if((i*75+20+55>320))
        {
            btn.frame = CGRectMake((i-4)*75+20, 125, 55, 55);
        }
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)share:(UIButton *)sender
{
//    NSLog(@"%@",urlString);
    if(self.sayContent){
        
    }
    switch (sender.tag) {
        case 11:
        {
            NSString *string = [NSString stringWithFormat:@"http://share.v.t.qq.com/index.php?c=share&a=index&title=分享了好东西哦\n%@&site=%@pic=&url=%@&appkey=dcba10cb2d574a48a16f24c9b6af610c&assname=${RALATEUID}",self.sayContent,urlString,urlString];
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
            break;
        }
        case 22:
        {
            NSString *string = [NSString stringWithFormat:@"http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=%@&title=分享了好东西哦\n%@&pics=%@&summary=文字详细介绍在这里",urlString,self.sayContent,urlString];
            NSLog(@"%@",string);
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
            break;
        }
        case 33:
        {
            NSString *string = [NSString stringWithFormat:@"http://widget.renren.com/dialog/share?resourceUrl=http://www.baidu.com&srcUrl=&title=&pic=&description=http://widget.renren.com/dialog/share?resourceUrl=%@&srcUrl=%@&title=分享了好东西哦\n%@&images=&pic=&description=文字详细介绍在这里",urlString,urlString,self.sayContent];
            NSLog(@"%@",string);
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"%@",encodingString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
            break;
        }
        case 44:
        {
            NSString *string = [NSString stringWithFormat:@"http://service.weibo.com/share/share.php?appkey=&title=分享了好东西哦\n%@&url=%@",self.sayContent,urlString];
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
            break;
        }
        case 55:
        {
            NSString *string = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%@文 字 详 细 介 绍 在 这 里",self.sayContent,urlString];
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
            break;
        }
        case 66:
        {
            NSString *string = [NSString stringWithFormat:@"https://plus.google.com/share?url=%@&type=st&gpsrc=frameless&rsz=1&client=3&hl=zh-CN",urlString];
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
            break;
        }
        case 77:
        {
            NSString *string = [NSString stringWithFormat:@"http://www.facebook.com/sharer/sharer.php?src=bm&u=%@%@&display=popup",self.sayContent,urlString];
            NSString *encodingString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodingString]];
           
            break;
        }
            
            
      default:
    break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [urlString release];
    [super dealloc];
}
@end
