//
//  BanBu_BroadcastTVC.m
//  BanBu
//
//  Created by Jc Zhang on 13-3-15.
//
//

#import "BanBu_BroadcastTVC.h"
#import "BanBu_DigiViewController.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "AppDataManager.h"
#import "BanBu_ProfileViewController.h"
#import "BanBu_PictureAndVoice.h"
@interface BanBu_BroadcastTVC ()

@end

NSInteger selectedRow;

@implementation BanBu_BroadcastTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    
    [_player release],_player = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"delete_Broadcast" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"xiangqingAction" object:nil];

    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = @"附近广播";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(320-55, 27, 50, 30);
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [listButton setTitle:NSLocalizedString(@"listButton", nil) forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(releaseRadio) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:listButton];

    
//    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    btn_return.frame=CGRectMake(5, 27, 48, 30);
    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn_return addTarget:self action:@selector(misPop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:btn_return];
    btn_return.alpha = 0;
    
//    UIBarButtonItem *bar_itemreturn=[[[UIBarButtonItem alloc] initWithCustomView:btn_return] autorelease];
//    self.navigationItem.leftBarButtonItem = bar_itemreturn;
//    [bar_itemreturn release];

    
    
  
    
    NSString *broadcastPath = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-broadcastdata",MyAppDataManager.useruid]];
    [MyAppDataManager.nearDos addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:broadcastPath]]];
    
//    NSLog(@"%@",MyAppDataManager.nearDos);
    
    //监听删除
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteBroadcastAction:) name:@"delete_Broadcast" object:nil];
    
    //监听从动态详情页面，点击标签事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fromDetialGoSearchBroad:) name:@"xiangqingAction" object:nil];
    //监听是否是第二次点击tabbar
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBroadcast) name:@"refreshBroadcast" object:nil];
    
    farDemeter = @"100000";
}

-(void)refreshBroadcast{
    [self setRefreshing];
}

-(void)deleteBroadcastAction:(NSNotification *)aNoti{
    
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[aNoti object] forKey:@"actid"];
    [AppComManager getBanBuData:BanBu_Delete_Broadcast par:parDic delegate:self];
    self.view.userInteractionEnabled = NO;
//    NSLog(@"%@",parDic);
    //    self.navigationController.view.userInteractionEnabled = NO;
 
}

-(void)releaseRadio{
    
    BanBu_PictureAndVoice *aPicAndVoice = [[BanBu_PictureAndVoice alloc]init];
    aPicAndVoice.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aPicAndVoice animated:YES];
    [aPicAndVoice release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"%d",_DosPage);
    if(!MyAppDataManager.nearDos.count ||!_DosPage){
        [self setRefreshing];
    }
 }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
         [UIView animateWithDuration:0.5 animations:^{
            
            btn_return.alpha = 0;
            listButton.alpha = 0;
            
        }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
         [UIView animateWithDuration:0.5 animations:^{
            
            if(isFirst){
                listButton.alpha = 0;
                btn_return.alpha = 1;
            }else{
                btn_return.alpha = 0;
                listButton.alpha = 1;
                
            }
        }];

 
}
-(void)fromDetialGoSearchBroad:(NSNotification *)notifi{
    isFirst = YES;
     UIButton *aButton = (UIButton *)[notifi object];
    keywordString = [aButton.titleLabel.text substringFromIndex:1];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"searchkey", nil),keywordString];
    [self setRefreshing];
    [UIView animateWithDuration:0.5 animations:^{
        btn_return.alpha = 1;
        listButton.alpha = 0;
        
    }];

}

//看标签的广播
-(void)goSearchBroad:(UIButton *)sender{
//    [AppComManager cancalHandlesForObject:self];

    keywordString = [sender.titleLabel.text substringFromIndex:1];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"searchkey", nil),keywordString];
    [self setRefreshing];
    [UIView animateWithDuration:0.5 animations:^{
        btn_return.alpha = 1;
        listButton.alpha = 0;

    }];
    isFirst = YES;
    
}

-(void)misPop{
//    [AppComManager cancalHandlesForObject:self];

    keywordString = @"";
    self.navigationItem.title = NSLocalizedString(@"broadcastTitle", nil);
    [self setRefreshing];
   
    [UIView animateWithDuration:0.5 animations:^{
        btn_return.alpha = 0;
        listButton.alpha = 1;
        
    }];
    isFirst = NO;
}
 

 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return MyAppDataManager.nearDos.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_DigiCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        
        cell = [[[BanBu_DigiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *aView = [[UIView alloc]init];
        aView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = aView;
        [aView release];

    }
    cell.delegate = self;
    NSDictionary *nearDo;
    NSDictionary *conDic;
    if(MyAppDataManager.nearDos.count){
        
        nearDo= [MyAppDataManager.nearDos objectAtIndex:indexPath.row];
//        nearDo= [MyAppDataManager.nearDos objectAtIndex:3];

    }else{
        nearDo= nil;
    }
//    NSLog(@"%@",nearDo);
    conDic = [nearDo valueForKey:@"mcontent"];
    cell.nameLabel.text = [nearDo objectForKey:@"pname"];
    if(![[nearDo objectForKey:@"adtime"] isEqualToString:@""] && ![[nearDo objectForKey:@"admeter"] isEqualToString:@""]){
        cell.distanceAndTimeLabel.text = [NSString stringWithFormat:@"%@/%@",[nearDo objectForKey:@"admeter"],[nearDo objectForKey:@"adtime"]];

    }
    cell.lastTimeLabel.text = [nearDo objectForKey:@"mtime"];
    [cell setAvatar:[nearDo objectForKey:@"uface"]];
    //按钮上的文字，来作为标示。 播放的语音也是一样的。
    [cell.iconButton setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
    
    /****************排版**********************/

    //文字
    
    BOOL _isText =![[conDic valueForKey:@"saytext"]isEqualToString:@""];
    if(_isText){
        
        
        //只有文字，没有标签
        if(cell.tagsView.subviews.count){
            for(UIButton *temp in cell.tagsView.subviews){
                [temp removeFromSuperview];
            }
            cell.tagsView.frame = CGRectZero;
 
        }
//        if(cell.tagsView){
//            [cell.tagsView removeFromSuperview];
//
//        }
        
        NSString *saytext = [conDic objectForKey:@"saytext"];
      
        if([saytext rangeOfString:@"-->"].location != NSNotFound && [saytext rangeOfString:@"<--"].location != NSNotFound){
//            NSLog(@"%@------%d%d",[saytext substringWithRange:NSMakeRange(start, end-start)],start,end);
            NSInteger start=[saytext rangeOfString:@"<--"].location+3;
            NSInteger end = [saytext rangeOfString:@"-->"].location;
            cell.sayTextLabel.text = [saytext substringToIndex:start-3];
            NSLog(@"%@",[saytext substringToIndex:start-3]);
            _textHeight = [cell.sayTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 100) lineBreakMode:NSLineBreakByTruncatingMiddle].height;
            cell.sayTextLabel.frame = CGRectMake(55, 55, 235, _textHeight);
            if([[nearDo objectForKey:@"telno"] length])
            {
                cell.telButton.frame = CGRectMake(55, 55+_textHeight+15, 150, 30);
                //                [cell.telButton setBackgroundColor:[UIColor redColor]];
                [cell.telButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
                [cell.telButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                //                [cell.telButton.titleLabel setTextColor:[UIColor blackColor]];
                [cell.telButton setTitle:[nearDo objectForKey:@"telno"] forState:UIControlStateNormal];
                _textHeight = _textHeight+30;
            }
                     
            NSString *tagString = [saytext substringWithRange:NSMakeRange(start, end-start)];
//            NSLog(@"%@",tagString);
          
            if(![tagString isEqualToString:@""])
            {
                if(cell.sayTextLabel.text.length){
                    _textHeight += 5;
                }
                NSArray *tagArray = [tagString componentsSeparatedByString:@" "];
                //            NSLog(@"%@",tagArray);

                CGFloat height= 0,width = 0;
                for(int i= 0;i<tagArray.count;i++){
                    NSString *buttonTitle = [NSString stringWithFormat:@"#%@",[tagArray objectAtIndex:i]];
                    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    aButton.backgroundColor = [UIColor clearColor];
                    [aButton setTitle:buttonTitle forState:UIControlStateNormal];
                    aButton.titleLabel.font = [UIFont systemFontOfSize:13];
                    [aButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    CGFloat buttonLength = [buttonTitle sizeWithFont:[UIFont systemFontOfSize:13]].width;
                    if(width > 235-buttonLength){
                        width = 0;
                        height += 15;
                    }
                    aButton.frame = CGRectMake(width, height, buttonLength, 17);
                    width += buttonLength+5;
                    [aButton addTarget:self action:@selector(goSearchBroad:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.tagsView addSubview:aButton];
                    
                }
                cell.tagsView.frame = CGRectMake(55, 55+_textHeight, 235, height+17);
                _textHeight += height + 17;
            }
        }
        else{
          
            
            cell.sayTextLabel.text = [conDic objectForKey:@"saytext"];
             NSLog(@"%d %@",indexPath.row,[conDic objectForKey:@"saytext"]);
            _textHeight = [cell.sayTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 100) lineBreakMode:NSLineBreakByTruncatingMiddle].height;
            cell.sayTextLabel.frame = CGRectMake(55, 55, 235, _textHeight);
            NSLog(@"%@",nearDo);
            if([[nearDo objectForKey:@"telno"] length])
            {
                cell.telButton.frame = CGRectMake(55, 55+_textHeight+15, 150, 30);
//                [cell.telButton setBackgroundColor:[UIColor redColor]];
                [cell.telButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
                [cell.telButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                [cell.telButton.titleLabel setTextColor:[UIColor blackColor]];
                [cell.telButton setTitle:[nearDo objectForKey:@"telno"] forState:UIControlStateNormal];
                _textHeight += 30;
            
            }
        }
       
 
       
        _textHeight += 10;
    }
    else{
        if(cell.tagsView.subviews.count)
        {
            for(UIButton *temp in cell.tagsView.subviews)
            {
                [temp removeFromSuperview];
            }
            cell.tagsView.frame = CGRectZero;
            
        }
        cell.telButton.frame = CGRectZero;                                           
//        if([[nearDo objectForKey:@"telno"] length])
//        {
//            cell.telButton.frame = CGRectMake(55, 55, 150, 30);
//            //                [cell.telButton setBackgroundColor:[UIColor redColor]];
//            [cell.telButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
//            [cell.telButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            //                [cell.telButton.titleLabel setTextColor:[UIColor blackColor]];
//            [cell.telButton setTitle:[nearDo objectForKey:@"telno"] forState:UIControlStateNormal];
//            _textHeight =30;
//        }
        
//        else
//        {
        cell.sayTextLabel.frame = CGRectZero;
        _textHeight = 0;
//        }
    }
    //图片和语音
    _imageContentString = nil;
    _soundContentString = nil;
    _soundTimeString = nil;

    for(NSDictionary *aDic in [conDic valueForKey:@"attach"]){
        if([[aDic valueForKey:@"type"] isEqualToString:@"image"]){
            if(![[aDic valueForKey:@"content"]isEqualToString:@""]){
                _imageContentString = [NSString stringWithString:[aDic valueForKey:@"content"]];

            }
        }else if([[aDic valueForKey:@"type"] isEqualToString:@"sound"]){
            if(![[aDic valueForKey:@"content"]isEqualToString:@""]){

                _soundContentString = [NSString stringWithFormat:@"0,%@",[aDic valueForKey:@"content"]];
                if([aDic valueForKey:@"length"]){
                    _soundTimeString = [NSString stringWithFormat:@"%@\"",[aDic valueForKey:@"length"]];
                    
                }
                
            }
        }
    }
    if(_imageContentString){
        [cell setHeadImage:_imageContentString];
        cell.headImageView.frame = CGRectMake(10, 55+_textHeight, 280,280);
        _headImageViewHeight = cell.headImageView.frame.size.height+10;
        if(_soundContentString){
            cell.playButton.frame = CGRectMake( 150-105/2, cell.headImageView.frame.origin.y + 280 -13, 105, 26);
            [cell.playButton setTitle:_soundContentString forState:UIControlStateNormal];
            [cell.playButton setImage:[UIImage imageNamed:@"播放语音_未按下_不空.png"] forState:UIControlStateNormal];

            cell.soundTimeLabel.text = _soundTimeString;
            cell.soundTimeLabel.frame = CGRectMake(cell.playButton.frame.origin.x+60-10-25+45, cell.playButton.frame.origin.y+3, 25, 20);
            _headImageViewHeight = cell.headImageView.frame.size.height+23;
        }else{
            cell.playButton.frame = CGRectZero;
            cell.soundTimeLabel.frame = CGRectZero;

        }
    }
    else{
        cell.headImageView.frame = CGRectZero;        
        cell.playButton.frame = CGRectZero;
        cell.soundTimeLabel.frame = CGRectZero;
        _headImageViewHeight = 0;

    }
    //评论
    BOOL _isReplylist = [[nearDo valueForKey:@"replylist"] count]?YES:NO;
    //    NSLog(@"-----------%d",_isReplylist);
//    NSLog(@"%@",[nearDo valueForKey:@"replylist"]);
    if(_isReplylist){
        NSArray *replyList = [NSArray array];
        
        replyList = [NSArray arrayWithArray:[nearDo valueForKey:@"replylist"]];
//        replyList = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
//            return [[obj1 objectForKey:@"actid"] compare:[obj2 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];
//            
//        }];
//        NSLog(@"%d",[replyList count]);
        
            
        cell.commentView.frame = CGRectMake(10, 55+_textHeight+_headImageViewHeight+10, 300, 30+ 55*[replyList count]);
 
        {
            cell.lineView1.frame = CGRectZero;
            cell.iconBtn1.frame = CGRectZero;
            cell.voiceBtn1.frame = CGRectZero;
            cell.nameLabel1.frame = CGRectZero;
            cell.textLabel1.frame = CGRectZero;
            cell.timeLabel1.frame =CGRectZero;
            
            cell.lineView2.frame = CGRectZero;
            cell.iconBtn2.frame = CGRectZero;
            cell.voiceBtn2.frame = CGRectZero;
            cell.nameLabel2.frame = CGRectZero;
            cell.textLabel2.frame = CGRectZero;
            cell.timeLabel2.frame =CGRectZero;
            
            cell.lineView3.frame = CGRectZero;
            cell.iconBtn3.frame = CGRectZero;
            cell.voiceBtn3.frame = CGRectZero;
            cell.nameLabel3.frame = CGRectZero;
            cell.textLabel3.frame = CGRectZero;
            cell.timeLabel3.frame =CGRectZero;
            
            cell.soundTimeLabel1.frame = CGRectZero;
            cell.soundTimeLabel2.frame = CGRectZero;
            cell.soundTimeLabel3.frame = CGRectZero;
            
        }
        for(int i=0; i<[replyList count]; i++){
//            NSLog(@"%@----**********",[[replyList objectAtIndex:i] valueForKey:@"mcontent"]);

            NSDictionary *replyContent = [AppComManager getAMsgFrom64String:[[replyList objectAtIndex:i] valueForKey:@"mcontent"]];
            
//    NSLog(@"%@-----%@",replyContent ,[replyList objectAtIndex:i]);
            if(i==0){
                //评论1
                cell.lineView1.frame = CGRectMake(0, 0, 300, 1);
                cell.iconBtn1.frame = CGRectMake(10, 10, 35, 35);
                [cell.iconBtn1 setTitle:[NSString stringWithFormat:@"%d-%d",indexPath.row,i]  forState:UIControlStateNormal];
                
                [cell.iconBtn1 setImageWithURL:[NSURL URLWithString:[[replyList objectAtIndex:0] valueForKey:@"uface"]] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
                cell.nameLabel1.text = [[replyList objectAtIndex:0] valueForKey:@"pname"];
                if([[replyContent valueForKey:@"saytext"]isEqualToString:@""]){
                    CGFloat nameWidth = [cell.nameLabel1.text sizeWithFont:cell.nameLabel1.font constrainedToSize:CGSizeMake(80, 17) lineBreakMode:UILineBreakModeTailTruncation].width;
                    cell.nameLabel1.frame = CGRectMake(55, 19, nameWidth, 17);
                    //语音按钮
                    [cell.voiceBtn1 setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
                    [cell.voiceBtn1 setTitle:[NSString stringWithFormat:@"1,%@",[[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"content"]] forState:UIControlStateNormal];
                    cell.voiceBtn1.frame = CGRectMake(cell.nameLabel1.frame.origin.x+nameWidth+10, 15, 60, 25);
                    if([[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"length"]){
                        cell.soundTimeLabel1.text = [NSString stringWithFormat:@"%@\"",[[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"length"]];
                        
                    }
                    
                    cell.soundTimeLabel1.frame = CGRectMake(cell.voiceBtn1.frame.origin.x+60-10-25, cell.voiceBtn1.frame.origin.y+2, 25, 20);
                    
                }else{
                    cell.nameLabel1.frame = CGRectMake(55, 10, 100, 17);
                    cell.textLabel1.frame = CGRectMake(55, 27, 160+75, 17);
                    cell.textLabel1.text = [replyContent valueForKey:@"saytext"];
                    //                    [cell.voiceBtn1 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
                    //                    cell.voiceBtn1.frame = CGRectZero;
                    
                    
                }
                cell.timeLabel1.frame =CGRectMake(215, cell.nameLabel1.frame.origin.y, 75, 17);
                cell.timeLabel1.text = [[replyList objectAtIndex:0] valueForKey:@"mtime"];
                
            }
            else if(i==1){
                cell.lineView2.frame = CGRectMake(0, 55, 300, 1);
                cell.iconBtn2.frame = CGRectMake(10, 10+55, 35, 35);
                [cell.iconBtn2 setTitle:[NSString stringWithFormat:@"%d-%d",indexPath.row,i]  forState:UIControlStateNormal];
                
                [cell.iconBtn2 setImageWithURL:[NSURL URLWithString:[[replyList objectAtIndex:1] valueForKey:@"uface"]] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
                cell.nameLabel2.text = [[replyList objectAtIndex:1] valueForKey:@"pname"];
                if([[replyContent valueForKey:@"saytext"]isEqualToString:@""]){
                    //                    NSLog(@"--------------22222222");
                    CGFloat nameWidth = [cell.nameLabel2.text sizeWithFont:cell.nameLabel2.font constrainedToSize:CGSizeMake(80, 17) lineBreakMode:UILineBreakModeTailTruncation].width;
                    cell.nameLabel2.frame = CGRectMake(55, 19+55, nameWidth, 17);
                    
                    //语音按钮
                    [cell.voiceBtn2 setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
                    [cell.voiceBtn2 setTitle:[NSString stringWithFormat:@"1,%@",[[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"content"]] forState:UIControlStateNormal];
                    
                    cell.voiceBtn2.frame = CGRectMake(cell.nameLabel2.frame.origin.x+nameWidth+10, 15+55, 60, 25);
                    
                    if([[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"length"]){
                        cell.soundTimeLabel2.text = [NSString stringWithFormat:@"%@\"",[[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"length"]];
                        
                    }
                    cell.soundTimeLabel2.frame = CGRectMake(cell.voiceBtn2.frame.origin.x+60-10-25, cell.voiceBtn2.frame.origin.y+2, 25, 20);
                    
                }
                else{
                    cell.nameLabel2.frame = CGRectMake(55, 10+55, 100, 17);
                    cell.textLabel2.frame = CGRectMake(55, 27+55, 160+75, 17);
                    cell.textLabel2.text = [replyContent valueForKey:@"saytext"];
                    //                    [cell.voiceBtn2 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
                    //                    cell.voiceBtn2.frame = CGRectZero;
                    
                    
                }
                cell.timeLabel2.frame =CGRectMake(215, cell.nameLabel2.frame.origin.y, 75, 17);
                cell.timeLabel2.text = [[replyList objectAtIndex:1] valueForKey:@"mtime"];
                //                NSLog(@"%@",cell.timeLabel2.text);
            }
            else if(i == 2){
                cell.lineView3.frame = CGRectMake(0, 55*2, 300, 1);
                cell.iconBtn3.frame = CGRectMake(10, 10+55*2, 35, 35);
                [cell.iconBtn3 setTitle:[NSString stringWithFormat:@"%d-%d",indexPath.row,i]  forState:UIControlStateNormal];
                
                [cell.iconBtn3 setImageWithURL:[NSURL URLWithString:[[replyList objectAtIndex:2] valueForKey:@"uface"]] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
                cell.nameLabel3.text = [[replyList objectAtIndex:2] valueForKey:@"pname"];
                if([[replyContent valueForKey:@"saytext"]isEqualToString:@""]){
                    CGFloat nameWidth = [cell.nameLabel3.text sizeWithFont:cell.nameLabel3.font constrainedToSize:CGSizeMake(80, 17) lineBreakMode:UILineBreakModeTailTruncation].width;
                    cell.nameLabel3.frame = CGRectMake(55, 19+55*2, nameWidth, 17);
                    //语音按钮
                    [cell.voiceBtn3 setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
                    [cell.voiceBtn3 setTitle:[NSString stringWithFormat:@"1,%@",[[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"content"]] forState:UIControlStateNormal];
                    
                    cell.voiceBtn3.frame = CGRectMake(cell.nameLabel3.frame.origin.x+nameWidth+10, 15+110, 60, 25);
                    if([[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"length"]){
                        cell.soundTimeLabel3.text = [NSString stringWithFormat:@"%@\"",[[[replyContent valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"length"]];
                        
                    }
                    cell.soundTimeLabel3.frame = CGRectMake(cell.voiceBtn3.frame.origin.x+60-10-25, cell.voiceBtn3.frame.origin.y+2, 25, 20);
                }else{
                    cell.nameLabel3.frame = CGRectMake(55, 10+55*2, 100, 17);
                    cell.textLabel3.frame = CGRectMake(55, 27+55*2, 160+75, 17);
                    cell.textLabel3.text = [replyContent valueForKey:@"saytext"];
                    //                    [cell.voiceBtn3 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
                    //                    cell.voiceBtn3.frame = CGRectZero;
                    
                }
                cell.timeLabel3.frame =CGRectMake(215, cell.nameLabel3.frame.origin.y, 75, 17);
                cell.timeLabel3.text = [[replyList objectAtIndex:2] valueForKey:@"mtime"];
            }
        }
        cell.numLabel.frame = CGRectMake(10, 55*[replyList count]+6.5, 180, 17);
        cell.numLabel.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"commentcount1", nil),[nearDo valueForKey:@"comments"],NSLocalizedString(@"commentcount2", nil)];
        cell.lineView4.frame = CGRectMake(0, cell.commentView.frame.size.height-30, 300, 1.0);
    }
    else{
        for(UIView *aTemp in cell.commentView.subviews){
            aTemp.frame = CGRectZero;
        }
                                                                                                                                                       
        cell.commentView.frame = CGRectMake(10, 55+_textHeight+_headImageViewHeight+10, 300, 30);
        
        cell.numLabel.frame = CGRectMake(10, 6.5, 180, 17);
        cell.numLabel.text = NSLocalizedString(@"footLabel", nil);
        cell.lineView4.frame = CGRectMake(0, cell.commentView.frame.size.height-30, 300, 1.0);
    }
   
    cell.shadowView.frame = CGRectMake(10, 10, 300, 55+_textHeight+_headImageViewHeight+cell.commentView.frame.size.height);
    
  
    CGRect arect = cell.frame;
    arect.size.height = cell.shadowView.frame.size.height+10;
    cell.frame = arect ;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height+10;
//    return 380-10+64;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Navigation logic may go here. Create and push another view controller.
    
//    NSData *sendImageData = nil;
//    
//    NSDictionary *aDic = [NSDictionary dictionaryWithDictionary:[AppComManager getAMsgFrom64String:[[MyAppDataManager.nearDos objectAtIndex:indexPath.section] valueForKey:@"mcontent"]]];
//    
//    for(NSDictionary *dic in [aDic valueForKey:@"attach"]){
//        if([[dic valueForKey:@"type"] isEqualToString:@"image"]){
////            NSLog(@"%@",[dic valueForKey:@"content"]);
//            sendImageData = [NSData data];
//        }
//    }
//    NSLog(@"%@",sendImageData);
    selectedRow = indexPath.row;
    BanBu_DigiViewController *aDigi = [[BanBu_DigiViewController alloc]initWithBroadcast:[MyAppDataManager.nearDos objectAtIndex:indexPath.row]];
    aDigi.selectSection = indexPath.row;
    aDigi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aDigi animated:YES];
    [aDigi release];
    
}

//查看个人资料
-(void)seeProfile:(UIButton *)sender{
    
//    NSLog(@"%@",sender.titleLabel.text);
    NSArray *messageArr = [sender.titleLabel.text componentsSeparatedByString:@"-"];
//    NSLog(@"%@",messageArr);
    NSDictionary *aDic = nil;

    if(messageArr.count == 1){
        aDic = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.nearDos objectAtIndex:[[messageArr objectAtIndex:0] intValue]]];
    }else if(messageArr.count == 2){
        
        NSArray *replyList = [NSArray arrayWithArray:[[MyAppDataManager.nearDos objectAtIndex:[[messageArr objectAtIndex:0] intValue]] valueForKey:@"replylist"]];
        
//         NSArray *tempArr = [NSArray arrayWithArray:[[MyAppDataManager.nearDos objectAtIndex:[[messageArr objectAtIndex:0] intValue]] valueForKey:@"replylist"]];
////        NSLog(@"%@",tempArr);
//        replyList = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
//            //                NSLog(@"%@",[obj1 objectForKey:@"actid"]);
//            return [[obj1 objectForKey:@"actid"] compare:[obj2 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];
//            
//        }];

        aDic = [NSDictionary dictionaryWithDictionary:[replyList objectAtIndex:[[messageArr objectAtIndex:1] intValue]]];
    }
//    NSLog(@"%@",aDic);
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:aDic displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}

// 语音的播放及动画
-(void)animation:(UIButton *)animationBtn
{
    
    if(animationBackgroundView){
        [animationBackgroundView removeFromSuperview];
    }
    
    NSArray *voiceArr = [_voiceButton.titleLabel.text componentsSeparatedByString:@","];
    if([[voiceArr objectAtIndex:0] boolValue]){
        animationBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
        animationBackgroundView.userInteractionEnabled = YES;
        [animationBackgroundView setImage:[UIImage imageNamed:@"广播详情-复选框-播放_空.png"]];
    }else{
        animationBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 105, 26)];
        animationBackgroundView.backgroundColor = [UIColor clearColor];
        animationBackgroundView.userInteractionEnabled = YES;

        [animationBackgroundView setImage:[UIImage imageNamed:@"播放语音_未按下.png"]];

    }
    
    
    NSArray *animationImages = [NSArray arrayWithObjects:@"feed_comment_player_pause_anim1.png",@"feed_comment_player_pause_anim2.png",@"feed_comment_player_pause_anim3.png", nil];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for(NSString *path in animationImages)
    {
        [images addObject:[UIImage imageNamed:path]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    if([[voiceArr objectAtIndex:0] boolValue]){
       
        imageView.frame = CGRectMake(13, 6.5, 10, 12);

    }else{
        imageView.frame = CGRectMake(24, 7, 10, 12);

    }
    imageView.userInteractionEnabled = YES;
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;

    imageView.backgroundColor = [UIColor clearColor];
    [animationBackgroundView addSubview:imageView];
    [imageView startAnimating];
    [imageView release];

    [animationBtn addSubview:animationBackgroundView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlay:)];
    [animationBackgroundView addGestureRecognizer:tap];
    [tap release];
    
    
}

-(void)stopPlay:(UITapGestureRecognizer *)tap{
    [_player stop];
    [tap.view removeFromSuperview];
 
    
}

-(void)playVoiceButton:(UIButton *)sender{
    
//    NSLog(@"%@",sender.titleLabel.text);
    _voiceButton = sender;
    NSArray *voiceArr = [_voiceButton.titleLabel.text componentsSeparatedByString:@","];
    if(![FileManager fileExistsAtPath:[AppComManager pathForMedia:[voiceArr lastObject]]]){
        
        [AppComManager getBanBuMedia:[voiceArr lastObject] delegate:self];
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
    }else{
        
        if(_player){
            
            [_player release],_player = nil;
        }
        NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:[voiceArr lastObject]]];

        _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
        _player.delegate = self;
        _player.volume = 1.0;
        [_player prepareToPlay];

        [_player play];
        [_playHUD startAnimating];
//        sender.hidden = YES;
        if([_player isPlaying]){
            [self animation:sender];
        }
        
    }
    
}

//下载语音

#pragma mark - BanBuDownloadRequest

- (void)banbuDownloadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error{
    //    NSLog(@"%@",resDic);
    
    NSArray *voiceArr = [_voiceButton.titleLabel.text componentsSeparatedByString:@","];

    
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
    if([[resDic valueForKey:@"ok"]boolValue]){
        if(_player){
            [_player release],_player = nil;
        }
        NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:[voiceArr lastObject]]];
        _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
        _player.delegate = self;
        _player.volume = 1.0;
        [_player prepareToPlay];
        [_player play];
        [_playHUD startAnimating];
        if([_player isPlaying]){
            [self animation:_voiceButton];
        }
    }else{
//        [TKLoadingView showTkloadingAddedTo:self.view title:@"下载失败" activityAnimated:NO duration:1.0];
    }
}

//播放完毕

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_player stop];
    [[_voiceButton.subviews lastObject]removeFromSuperview]; 
}

//加载数据

-(void)loadingData{
    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
        [[self.view viewWithTag:102]removeFromSuperview];

    }
    if(_isLoadingRefresh){
        [AppLocationManager getLocation];
        _DosPage = 1;
    }else{
        _DosPage++;
//        if(_DosPage == 1){
//            _DosPage = 1;
//        }
    }
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
    [parDic setValue:[NSString stringWithFormat:@"%i",_DosPage] forKey:PageNo];
    [parDic setValue:keywordString forKey:@"keyword"];
    [parDic setValue:farDemeter forKey:@"distlimit"];
//    NSLog(@"%@",farDemeter);
    NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
    //    NSLog(@"%@",langauage);
    
    if([langauage isEqual:@"zh"]){
        [parDic setValue:@"cn" forKey:@"lang"];
        
    }else if([langauage isEqual:@"ja"]){
        [parDic setValue:@"jp" forKey:@"lang"];
    }else{
        [parDic setValue:@"en" forKey:@"lang"];
    }
    [AppComManager getBanBuData:BanBu_Get_User_Neardo par:parDic delegate:self];
    //    self.navigationController.view.userInteractionEnabled = NO;
    //NSLog(@"%@",parDic);
    
}

#pragma mark - BanBuRequetDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
            self.view.userInteractionEnabled = YES;
    self.navigationController.view.userInteractionEnabled =YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    if(error)
    {
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }

        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        [self finishedLoading];
        return;
    }
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_User_Neardo]){
        if([[resDic valueForKey:@"ok"] boolValue]){
            NSArray *reportArr =  [UserDefaults valueForKey:@"reportList"];
            
            if(_isLoadingRefresh)
            {
                [MyAppDataManager.nearDos removeAllObjects];
                //对名字和话，进行替换后，在存储
                for(int i=0;i<[[resDic valueForKey:@"list"]count];i++){
                    
                    NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
                    //先解开base64的“mcontent”，然后替换多语言和备注名字
                    NSMutableDictionary *mcontentDic = [NSMutableDictionary dictionaryWithDictionary:[AppComManager getAMsgFrom64String:[aDic valueForKey:@"mcontent"]]];
//                    NSMutableString *saytextStr = [NSMutableString stringWithString:[mcontentDic valueForKey:@"saytext"]];
//                    if([saytextStr rangeOfString:@"__modifyuserfile__"].location != NSNotFound){
////                        NSLog(@"%@",saytextStr);
//
//                        if([[MyAppDataManager getPreferredLanguage] isEqual:@"zh-Hans"]){
//                            [saytextStr deleteCharactersInRange:NSMakeRange([saytextStr rangeOfString:@"__modifyuserfile__"].location, 18)];
//                             
//                            saytextStr = (NSMutableString *)[@"__modifyuserfile__ " stringByAppendingString:saytextStr];
////                            NSLog(@"%@",saytextStr);
//                            
//                        }
//                    }
                    
//                    [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:(NSString *)saytextStr] forKey:@"saytext"];
    
                    [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:[mcontentDic valueForKey:@"saytext"]] forKey:@"saytext"];

                    [aDic setValue:mcontentDic  forKey:@"mcontent"];
//                    NSLog(@"%@-------%@",aDic,mcontentDic);
                    if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]){
                        [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                        
                    }
                    //解回复列表里的"mcontent",
                    
                    
                    //被举报的广播不显示。
                    BOOL isReported = NO;
//                    NSLog(@"%@",reportArr);
                    if(reportArr.count){
                        for(NSString *reportStr in reportArr){
                            if([reportStr isEqualToString:[aDic valueForKey:@"actid"]]){
                                isReported = YES;
                                break;
                            }
                        }
                    }
                   
                    if(!isReported){
                        [MyAppDataManager.nearDos addObject:aDic];

                    }
                    
                }
            }
            else{
                NSMutableArray *filterArr = [NSMutableArray arrayWithArray:[resDic valueForKey:@"list"]];
                NSMutableArray *congfuArr = [NSMutableArray array];

                for(int i=0;i<[[resDic valueForKey:@"list"] count];i++){
                    
                    
                    //被举报的广播不显示。
                    BOOL isReported = NO;
//                    NSLog(@"%@",reportArr);
                    if(reportArr.count){
                        for(NSString *reportStr in reportArr){
                            if([reportStr isEqualToString:[[filterArr objectAtIndex:i] valueForKey:@"actid"]]){
                                isReported = YES;
                                break;
                            }
                        }
                    }
                    if(isReported){
                        [congfuArr addObject:[filterArr objectAtIndex:i]];
                    }
                    
                    
                    for(int j=0;j<MyAppDataManager.nearDos.count;j++){
                        if([[[[resDic valueForKey:@"list"] objectAtIndex:i] valueForKey:@"actid"] isEqualToString:[[MyAppDataManager.nearDos objectAtIndex:j] valueForKey:@"actid"]]){
                            //                    NSLog(@"%@----%@",[[reArray objectAtIndex:i] valueForKey:@"userid"],[[reArray objectAtIndex:j] valueForKey:@"userid"]);
//                            [filterArr removeObjectAtIndex:j];
                            [congfuArr addObject:[MyAppDataManager.nearDos objectAtIndex:j]];
                        }else{
                            NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
                            
                            NSMutableDictionary *mcontentDic = [NSMutableDictionary dictionaryWithDictionary:[AppComManager getAMsgFrom64String:[aDic valueForKey:@"mcontent"]]];
                            //                            NSMutableString *saytextStr = [NSMutableString stringWithString:[mcontentDic valueForKey:@"saytext"]];
                            //
                            //                            if([saytextStr rangeOfString:@"__modifyuserfile__"].location != NSNotFound){
                            //
                            //                                if([[MyAppDataManager getPreferredLanguage] isEqual:@"zh-Hans"]){
                            //                                    [saytextStr deleteCharactersInRange:NSMakeRange([saytextStr rangeOfString:@"__modifyuserfile__"].location-1, 19)];
                            //
                            //                                    saytextStr = (NSMutableString *)[@"__modifyuserfile__ " stringByAppendingString:saytextStr];
                            //                                    //                            NSLog(@"%@",saytextStr);
                            //
                            //                                }
                            //                            }
                            //
                            //                            [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:(NSString *)saytextStr] forKey:@"saytext"];
                            [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:[mcontentDic valueForKey:@"saytext"]] forKey:@"saytext"];
                            [aDic setValue:mcontentDic forKey:@"mcontent"];
                            
                            
                            if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]){
                                [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                                
                            }
                            [filterArr replaceObjectAtIndex:i withObject:aDic];
                        }
                    }
                }
                [filterArr removeObjectsInArray:congfuArr];
                [MyAppDataManager.nearDos addObjectsFromArray:filterArr];
            }
            
//            NSArray *tempArr = [[[NSArray alloc]initWithArray:MyAppDataManager.nearDos]autorelease];
//            NSArray *sortedArray = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                //                NSLog(@"%@",[obj1 objectForKey:@"actid"]);
//                return [[obj2 objectForKey:@"actid"] compare:[obj1 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];
//                
//            }];
//            [MyAppDataManager.nearDos removeAllObjects];
//            [MyAppDataManager.nearDos addObjectsFromArray:sortedArray];
            [self.tableView reloadData];

            
            
            
            
            
            /*
            //先排序，后追加，再去重。
            NSArray *tempArr = [[[NSArray alloc]initWithArray:[resDic valueForKey:@"list"]]autorelease];
            NSArray *sortedArray = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
                //                NSLog(@"%@",[obj1 objectForKey:@"actid"]);
                return [[obj2 objectForKey:@"actid"] compare:[obj1 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];
                
            }];
            
            [MyAppDataManager.nearDos addObjectsFromArray:sortedArray];
            
            //去重
            
            for(int i=0;i<MyAppDataManager.nearDos.count;i++){
                //            NSLog(@"%@",[[reArray objectAtIndex:i] valueForKey:@"userid"]);
                for(int j=i+1;j<MyAppDataManager.nearDos.count;j++){
                    
                    if([[[MyAppDataManager.nearDos objectAtIndex:i] valueForKey:@"actid"] isEqualToString:[[MyAppDataManager.nearDos objectAtIndex:j] valueForKey:@"actid"]]){
                        
                        [MyAppDataManager.nearDos removeObjectAtIndex:j];
                        
                    }
                }
                
            }
            */
//            NSLog(@"-----------------%d",MyAppDataManager.nearDos.count);

            if([MyAppDataManager.nearDos count]){
                
                [self setLoadingMore:YES];
                
            }else{
                [self setLoadingMore:NO];
                if(cryImageView || noticeLabel){
                    [[self.view viewWithTag:100]removeFromSuperview];
                    [[self.view viewWithTag:101]removeFromSuperview];
                    [[self.view viewWithTag:102]removeFromSuperview];

                }
                cryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(136, 100, 48, 48)];
                cryImageView.tag = 100;
                cryImageView.image = [UIImage imageNamed:@"cry.png"];
                [self.tableView addSubview:cryImageView];
                [cryImageView release];
                noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 100)];
                noticeLabel.tag = 101;
                noticeLabel.numberOfLines = 0;
                noticeLabel.text = NSLocalizedString(@"noticeLabel1", nil);
                noticeLabel.textColor = [UIColor darkGrayColor];
                
                noticeLabel.font = [UIFont systemFontOfSize:16];
                noticeLabel.textAlignment = UITextAlignmentCenter;
                noticeLabel.backgroundColor = [UIColor clearColor];
                [self.tableView addSubview:noticeLabel];
                [noticeLabel release];
                
                
                footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, 320, 100)];
                footerView.backgroundColor = [UIColor clearColor];
                footerView.tag = 102;
                [self.tableView addSubview:footerView];
                [footerView release];
                
                UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                searchBtn.frame = CGRectMake(15, 0, 290, 40);
                [searchBtn setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [searchBtn setTitle:NSLocalizedString(@"listButton", nil) forState:UIControlStateNormal];
                [searchBtn addTarget:self action:@selector(releaseRadio) forControlEvents:UIControlEventTouchUpInside];
                for(int i=0;i<2;i++){
                    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    aButton.frame = CGRectMake(137.5*i+15*(i+1), 40+15, 137.5, 40);
                    [aButton setBackgroundImage:[UIImage imageNamed:@"加为好友.png"] forState:UIControlStateNormal];
                    aButton.tag = 1000+i;
                    if(i){
                        [aButton setTitle:NSLocalizedString(@"km2000", nil) forState:UIControlStateNormal];
                    }else{
                        [aButton setTitle:NSLocalizedString(@"km500", nil) forState:UIControlStateNormal];

                    }
                    aButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    [aButton addTarget:self action:@selector(searchFar:) forControlEvents:UIControlEventTouchUpInside];
                    [footerView addSubview:aButton];
                    
                }
                
                [footerView addSubview:searchBtn];
                
                
            }
            
            __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSData *broadcastData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.nearDos];
                NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-broadcastdata",MyAppDataManager.useruid]];
                [broadcastData writeToFile:path atomically:YES];
                
                //            NSData *contentArrData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.contentArr];
                //            NSString *path1 = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-contentArrdata",MyAppDataManager.useruid]];
                //            [contentArrData writeToFile:path1 atomically:YES];
                
            });
            
//            [BanBu_RefreshTime getCurrentTime:@"squares_updateTime"];

        }
        
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Delete_Broadcast]){
         if([[resDic valueForKey:@"ok"] boolValue])
        [MyAppDataManager.nearDos removeObject:[MyAppDataManager.nearDos objectAtIndex:selectedRow]];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    [self finishedLoading];    
}

-(void)searchFar:(UIButton *)sender{
    
    if(sender.tag == 1000){
        farDemeter = @"500000";
    }else if(sender.tag == 1001){
        farDemeter = @"2000000";
    }
    [self setRefreshing];
    
}

@end
