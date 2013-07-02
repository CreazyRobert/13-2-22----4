//
//  BanBu_twoDynamicController.m
//  BanBu
//
//  Created by apple on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "BanBu_DynamicDetailsController.h"
#import "UIImageView+WebCache.h"
#import "BanBu_PeopleProfileController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "MWPhotoBrowser.h"
#import "BanBu_LampText.h"
@interface BanBu_DynamicDetailsController ()

@end

@implementation BanBu_DynamicDetailsController
@synthesize dynamic = _dynamic;

-(id)initWithDynamic:(NSDictionary *)dynamicDic{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        _dynamic = [[NSMutableDictionary alloc]initWithDictionary:dynamicDic];
//        NSLog(@"%@",_dynamic);
        
    }
    return self;
}
// 隐藏掉   tabbar



//-(void)sdImageManagerDidLoadImageWithUrl:(NSURL *)url forImageView:(UIImageView *)imageView image:(UIImage *)image fromLocal:(BOOL)loadFromLocal{
//    [self.tableView reloadData];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = [self.dynamic valueForKey:@"pname"];
//    [BanBu_LampText showNavTitle:self title:self.title width:50];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    CGFloat btnLen = [NSLocalizedString(@"profileButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
//    NSLog(@"%f",btnLen);
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(0, 0, btnLen+10, 30);
    [profileButton addTarget:self action:@selector(seeProfile) forControlEvents:UIControlEventTouchUpInside];
    [profileButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [profileButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [profileButton setTitle:NSLocalizedString(@"profileButton", nil) forState:UIControlStateNormal];
    profileButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *profileItem = [[[UIBarButtonItem alloc] initWithCustomView:profileButton] autorelease];
    self.navigationItem.rightBarButtonItem = profileItem;
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushTobigPic:) name:@"labelText" object:nil];
    
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:2];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(banBuReplySuccessed) name:@"replySuc" object:nil];
    
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    footer.backgroundColor = [UIColor redColor];
//    self.tableView.tableFooterView = footer;
//    [footer release];
//    
//    
//    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 230, 40)];
//    //textView.delegate = self;
//    _inputView = textView;
//    textView.backgroundColor = [UIColor whiteColor];
//    textView.layer.borderColor = [[UIColor grayColor] CGColor];
//    textView.layer.borderWidth = 1.0;
//    textView.layer.cornerRadius = 6.0;
//    textView.textColor = [UIColor darkTextColor];
//    textView.font = [UIFont systemFontOfSize:16];
//    [footer addSubview:textView];
//    [textView release];
//    
//    UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    footButton.frame = CGRectMake(250, 10, 60, 40);
//    [footButton addTarget:self action:@selector(pushNextViewController) forControlEvents:UIControlEventTouchUpInside];
//    footButton.titleLabel.numberOfLines = 0;
//    [footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [footButton setTitle:NSLocalizedString(@"replyTitle", nil) forState:UIControlStateNormal];
//    [footButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [footer addSubview:footButton];


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!_success){
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
        [pars setValue:[_dynamic valueForKey:@"actid"] forKey:@"actid"];
        [AppComManager getBanBuData:BanBu_Get_Broadcast par:pars delegate:self];
//        self.navigationController.view.userInteractionEnabled = NO;

        [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 160) title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES ];
//        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
        aBNC = (BanBu_NavigationController *)self.navigationController;
        aBNC.isLoading = YES;
        
        
//        self.navigationController.view.userInteractionEnabled = NO;
        //NSLog(@"%@",pars);
//        self.navigationController.view.userInteractionEnabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

    [AppComManager cancalHandlesForObject:self];
    
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    MyAppDataManager.k = 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    footer.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    //        self.tableView.tableFooterView = footer;
    //        [footer release];
    if(section == 0){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
        lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
        [footer addSubview:lineView];
        [lineView release];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 230, 40)];
        textView.delegate = self;
        _inputView = textView;
        textView.returnKeyType = UIReturnKeyDone;
        textView.backgroundColor = [UIColor whiteColor];
        textView.layer.borderColor = [[UIColor grayColor] CGColor];
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 6.0;
        textView.textColor = [UIColor darkTextColor];
        textView.font = [UIFont systemFontOfSize:16];
        [footer addSubview:textView];
        [textView release];
        
        UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        footButton.frame = CGRectMake(250, 10, 60, 40);
        [footButton addTarget:self action:@selector(sendReply) forControlEvents:UIControlEventTouchUpInside];
        footButton.titleLabel.numberOfLines = 0;
        [footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footButton setTitle:NSLocalizedString(@"replyTitle", nil) forState:UIControlStateNormal];
        [footButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [footer addSubview:footButton];
    }
    return [footer autorelease];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)sendReply{
    if([_inputView isFirstResponder]){
        [_inputView resignFirstResponder];

    }
    NSString *clearTrimStri = [_inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _inputView.text = clearTrimStri;
    if(_inputView.text.length){
        NSMutableDictionary *abrd = [NSMutableDictionary dictionaryWithCapacity:2];
        [abrd setValue:_inputView.text forKey:@"saytext"];
        [abrd setValue:[NSArray array] forKey:@"attach"];
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
        [pars setValue:[_dynamic valueForKey:@"actid"] forKey:@"replyid"];
        [pars setValue:abrd forKey:@"says"];
        [AppComManager getBanBuData:BanBu_Reply_Broadcast par:pars delegate:self];
        self.navigationController.view.userInteractionEnabled = NO;
        //    self.navigationController.view.userInteractionEnabled = NO;
    }
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.dynamic = nil;
    _success = NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{

    [_dynamic release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"labelText" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"replySuc" object:nil];
    [super dealloc];
}



- (void)seeProfile
{
    if([_inputView isFirstResponder] ){
        [_inputView resignFirstResponder];

    }

//    if([_dynamic valueForKey:@"replylist"]){
//        [_dynamic removeObjectForKey:@"replylist"];
//
//    }
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:_dynamic displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}

#pragma tableview delegate is function

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%d",1+[[self.dynamic objectForKey:@"comments"]intValue]);
    if([[self.dynamic objectForKey:@"replylist"] count]){
        return 1+[[self.dynamic objectForKey:@"replylist"] count];
    }else{
        return 1+[[self.dynamic objectForKey:@"comments"]intValue];

    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height+10;
  
    
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndefier=@"Banbu_dynamiccell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndefier];
    if(cell==nil)
    {
    
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier]autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
     
    }
    // 去掉以前的Banbu_dynamiccell
    for(BanBu_DynamicCell *banbucell in cell.contentView.subviews)
    {
        if([banbucell isKindOfClass:[BanBu_DynamicCell class]])
        {
            [banbucell removeFromSuperview];
            break;
        }  
    }
    BanBu_DynamicCell *mycell=[[BanBu_DynamicCell alloc]initWithFrame:CGRectZero];
    mycell.delegate=self;
    [cell.contentView addSubview:mycell];

    if(indexPath.row){
        mycell.type = DynamicTa;
        if([[self.dynamic objectForKey:@"replylist"]count]){
            NSDictionary *replyDic = [[self.dynamic objectForKey:@"replylist"] objectAtIndex:indexPath.row-1];
            [mycell setAvatar:[replyDic objectForKey:@"uface"]];
            mycell.nameLabel.text = [replyDic objectForKey:@"pname"];
            mycell.timeString = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"replyTime", nil),[replyDic valueForKey:@"mtime"]];
            mycell.age = [replyDic objectForKey:@"oldyears"];
            mycell.sexbtnString = [replyDic objectForKey:@"gender"];
            mycell.starString = [replyDic valueForKey:@"sstar"];
            NSDictionary *reply_contentDic = [AppComManager getAMsgFrom64String:[replyDic objectForKey:@"mcontent"]];
            mycell.descriptionString = [NSString stringWithFormat:@"           %@",[MyAppDataManager IsMinGanWord:[reply_contentDic objectForKey:@"saytext"]]];
            mycell.zhuanfabtnString = [NSString stringWithFormat:@"      %@-%d",NSLocalizedString(@"reportLabel", nil),indexPath.row];
//            NSLog(@"%d",mycell.selctedRow);


        }else{
            mycell.userInteractionEnabled = NO;
        }
    }
    else{
        mycell.type = DynamicMe;
        [mycell setAvatar:[self.dynamic valueForKey:@"uface"]];

        mycell.timeString = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"intimeLabel", nil),[self.dynamic valueForKey:@"mtime"]];
        mycell.zhuanfabtnString = [NSString stringWithFormat:@"      %@-%d",NSLocalizedString(@"reportLabel", nil),indexPath.row];

        NSDictionary *broadDic = [self.dynamic valueForKey:@"mcontent"];
        
        NSString *saytext = [broadDic objectForKey:@"saytext"];
        if([saytext rangeOfString:@"-->"].location != NSNotFound && [saytext rangeOfString:@"<--"].location != NSNotFound){
 
            NSInteger start=[saytext rangeOfString:@"<--"].location+3;
             mycell.descriptionString =  [saytext substringToIndex:start-3] ;

        }else{
            mycell.descriptionString =  saytext;
            
        }

        NSArray *attachArr = [broadDic objectForKey:@"attach"];
        imageArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dic in attachArr){
            
            if([[dic objectForKey:@"type"] isEqualToString:@"image"]){
                [imageArr addObject:[dic objectForKey:@"content"]];
                //NSLog(@"%@",imageArr);

            }else if([[dic objectForKey:@"type"] isEqualToString:@"location"]){
                
            }
        }
    
        mycell.picArr=imageArr;
//        mycell.commitbtnString = [NSString stringWithFormat:@"      %@%d",NSLocalizedString(@"commendLabel", nil),[[self.dynamic objectForKey:@"replylist"]count]];
        mycell.commitbtnString = [NSString stringWithFormat:@"%d",[[self.dynamic objectForKey:@"replylist"]count]];

        //        //NSLog(@"%@",[self.dynamic objectForKey:@"comments"]);
//        mycell.zhuanfabtnString=@"转发";
    }
    
    cell.frame=mycell.frame;
    return cell;
}

-(void)getReplyPeopleInfo:(NSIndexPath *)indexPath{
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
    [pars setValue:[[[self.dynamic objectForKey:@"replylist"] objectAtIndex:indexPath.row-1] valueForKey:@"userid"] forKey:@"email_uid"];
    [AppComManager getBanBuData:BanBu_Get_User_Info par:pars delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
//    self.navigationController.view.userInteractionEnabled = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_inputView resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    select = tableView.indexPathForSelectedRow;
    if(indexPath.row){
        if([_inputView isFirstResponder]){
            [_inputView resignFirstResponder];
            [self performSelector:@selector(getReplyPeopleInfo:) withObject:indexPath afterDelay:0.3];
        }else{
            [self performSelector:@selector(getReplyPeopleInfo:) withObject:indexPath];

        }
        
       
    }
   
    
}

-(void)transFormtheNew:(NSInteger)selectedrow
{
//    NSLog(@"%d",selectedrow);
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
    if([_dynamic objectForKey:@"replylist"]){
        if(selectedrow == 0){
            [pars setValue:[_dynamic  objectForKey:@"actid"] forKey:@"actid"];
        }else{
            
            [pars setValue:[[[_dynamic objectForKey:@"replylist"] objectAtIndex:selectedrow-1] objectForKey:@"actid"] forKey:@"actid"];

        }
    }else{
        [pars setValue:[_dynamic  objectForKey:@"actid"] forKey:@"actid"];

    }
    [AppComManager getBanBuData:BanBu_Report_Broadcat par:pars delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"reportNotice", nil) activityAnimated:NO duration:2.0];
//    NSLog(@"%@",pars);
    
}

-(void)pushNextViewController{
////    //NSLog(@"%@",[_dynamic valueForKey:@"actid"]);
//    BanBu_ReplyViewController *aEditer = [[BanBu_ReplyViewController alloc]initWithTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"replyTitle", nil)] replyid:[_dynamic valueForKey:@"actid"]];
////    aEditer.delegate = self;
//    [self.navigationController pushViewController:aEditer animated:YES];
//    [aEditer release];
    [_inputView becomeFirstResponder];
}

// 点击图片放大功
-(void)pushTobigPic:(NSNumber *)sender
{
    //    //NSLog(@"%@",[imageArr objectAtIndex:0]);
    //    MWPhoto *mwPhoto = [MWPhoto photoWithImage:[sender object]];
    NSLog(@"%@",dataArr);
    if(dataArr.count){
        [dataArr removeAllObjects];
    }
    if(!dataArr.count){
        for (int i=0; i<imageArr.count; i++) {
            //            MWPhoto *mwPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]]];
            MWPhoto *mwPhoto = [MWPhoto photoWithImage: [MyAppDataManager imageForImageUrlStr:[imageArr objectAtIndex:i]]];
            [dataArr addObject:mwPhoto];
        }
    }
    selectedImageIndex = [sender integerValue]/10-1;
    NSLog(@"%d",selectedImageIndex);
    //    //NSLog(@"%d",imageArr.count);
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    //    [self presentModalViewController:nc animated:YES];
    [self presentViewController:nc animated: YES completion:NULL];
    [nc release];
    
   	[browser release];

}
//-(void)pushTobigPic:(NSNotification *)sender
//{
////    //NSLog(@"%@",[imageArr objectAtIndex:0]);
////    MWPhoto *mwPhoto = [MWPhoto photoWithImage:[sender object]];
//    NSLog(@"%@",dataArr);
//    if(dataArr.count){
//        [dataArr removeAllObjects];
//    }
//    if(!dataArr.count){
//        for (int i=0; i<imageArr.count; i++) {
////            MWPhoto *mwPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]]];
//            MWPhoto *mwPhoto = [MWPhoto photoWithImage: [MyAppDataManager imageForImageUrlStr:[imageArr objectAtIndex:i]]];
//            [dataArr addObject:mwPhoto];
//        }
//    }
//    selectedImageIndex = [[sender object] integerValue]/10-1;
//    NSLog(@"%d",selectedImageIndex);
////    //NSLog(@"%d",imageArr.count);
//    
//    
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = YES;
//    [browser setInitialPageIndex:0];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
////    [self presentModalViewController:nc animated:YES];
//    [self presentViewController:nc animated: YES completion:NULL];
//    [nc release];
//    
//   	[browser release];
////    [UIView animateWithDuration:1.0 animations:^(void){
////        
////        //        CATransition *transation=[[CATransition alloc]init];
////        
////        CATransition *transation=[CATransition animation];
////        
////        transation.timingFunction = UIViewAnimationCurveEaseInOut;
////        transation.type = @"rippleEffect";
////        
////        
////        [self.view.layer addAnimation:transation forKey:@"animation"];
////        
////    } completion:^(BOOL finished){
//    
//        
//        
//        // 隐藏掉自定义的tabbar
//        
////        [self hideTabbar:YES];
//    
//    /*
//    
//    
//    [[self.navigationController.view.subviews objectAtIndex:1] setHidden:YES];
//    
//    
//    
//        [self.navigationController.navigationBar setHidden:YES];
//        
//        // 加载新的视图
//        
//        UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height )];
//        
//        [rootView setBackgroundColor:[UIColor redColor]];
//        
//        rootView.tag=12;
//        
//        
//        UIImageView *bigImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50, 250, 300)];
//        
//        bigImage.userInteractionEnabled=YES;
//        
//        
//        bigImage.center=rootView.center;
//        
//        bigImage.image=[UIImage imageNamed:[[dataArr objectAtIndex:select.row] objectForKey:@"post"]];
//        
//        // 对 这张大图片添加一个手势 让他 显现toolbar
//        
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toshow:)];
//        
//        [bigImage addGestureRecognizer:tap];
//        
//        [tap release];
//        
//        
//        [rootView addSubview:bigImage];
//        
//        [bigImage release];
//        
////        [self.view insertSubview:rootView aboveSubview:self.navigationController.view];
//    
//    [self.navigationController.view addSubview:rootView];
//    
//        [rootView release];
//    
////    }];
//   */
//}

-(void)information{
    
    [self seeProfile];
    
}

-(void)sendMessageTochat{
    
    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"saveToAlum", nil),nil];
    //    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",NSLocalizedString(@"shareToTX", nil),NSLocalizedString(@"shareToSina", nil),nil];
    
    conSheet.tag = 101;
    [conSheet showInView:self.view];
    [conSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 101){
        if(buttonIndex == actionSheet.cancelButtonIndex){
            return;
        }
        if(buttonIndex == actionSheet.firstOtherButtonIndex){
            NSLog(@"%d",selectedImageIndex);
//            UIImageWriteToSavedPhotosAlbum([MyAppDataManager imageForImageUrlStr:[imageArr objectAtIndex:selectedImageIndex]], self, @selector(saveSuccess), nil);
            UIImageWriteToSavedPhotosAlbum([MyAppDataManager imageForImageUrlStr:[imageArr objectAtIndex:selectedImageIndex]], nil, nil, nil);

        }
    }
}

-(void)saveSuccess{
    NSLog(@"");
}

-(void)changeBack
{
//    [self hideTabbar:NO];
    [self.navigationController.navigationBar setHidden:NO];
    UIView *contentView=(UIView *)[self.view viewWithTag:12];
    [contentView removeFromSuperview];
    
}

#pragma mark - BanBu_Request

-(void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    aBNC.isLoading = NO;
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error){
        if([error.domain isEqualToString:BanBuDataformatError]){
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }else{
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        return;

    }
    
//    NSLog(@"%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Broadcast]){
        if([[resDic valueForKey:@"ok"]boolValue]){

            if([[resDic valueForKey:@"replylist"]count]){
//                NSLog(@"%@",[resDic valueForKey:@"replylist"]);
                NSMutableArray *beforeArr = [NSMutableArray arrayWithArray:[resDic valueForKey:@"replylist"]];
                NSMutableArray *afterArr = [NSMutableArray array];
                NSInteger numComments = beforeArr.count;
                for (int i=0 ;i<numComments;i++) {
                    [afterArr addObject:[beforeArr lastObject]];
                    if(beforeArr.count){
                        [beforeArr removeLastObject];
                        
                    }
                }
                [_dynamic setValue:afterArr forKey:@"replylist"];
//                NSArray *sortedArray = [beforeArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                    if ([[obj2 objectForKey:@"actid"] integerValue] > [[obj1 objectForKey:@"actid"] integerValue]) {
//                        return (NSComparisonResult)NSOrderedDescending;
//                    }
//                    if ([[obj2 objectForKey:@"actid"] integerValue] < [[obj1 objectForKey:@"actid"] integerValue]) {
//                        return (NSComparisonResult)NSOrderedAscending;
//                    }
//                    return (NSComparisonResult)NSOrderedSame;
//                }];
//                [_dynamic setValue:sortedArray forKey:@"replylist"];
//                self.tableView.tableFooterView = nil;
            }else{
//                UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 145)];
//                footer.backgroundColor = [UIColor clearColor];
//                self.tableView.tableFooterView = footer;
//                [footer release];
//                
////                UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 145)];
////                footLabel.numberOfLines = 0;
////                footLabel.backgroundColor = [UIColor redColor];
////                footLabel.text = NSLocalizedString(@"footLabel", nil);
////                footLabel.textAlignment = UITextAlignmentCenter;
////                footLabel.font = [UIFont systemFontOfSize:13];
////                [footer addSubview:footLabel];
////                [footLabel release];
//                
//                UIButton *footButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                footButton.frame = CGRectMake(10, 50, 300, 90);
//                [footButton addTarget:self action:@selector(pushNextViewController) forControlEvents:UIControlEventTouchUpInside];
//                footButton.titleLabel.numberOfLines = 0;
//                [footButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//                [footButton setTitle:NSLocalizedString(@"footLabel", nil) forState:UIControlStateNormal];
//                [footButton setBackgroundImage:[[UIImage imageNamed:@"btn_big_normal_normal.9.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10] forState:UIControlStateNormal];
//                [footButton setBackgroundImage:[[UIImage imageNamed:@"btn_big_normal_press.9.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0] forState:UIControlStateHighlighted];
//                [footButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
//                [footer addSubview:footButton];
            }
            [self.tableView reloadData];
            if(_success){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[_dynamic valueForKey:@"replylist"] count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

            }
            _success = YES;
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Report_Broadcat]){
        if(![[resDic valueForKey:@"ok"]boolValue]){
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_User_Info]){
        
//        
//        BanBu_PeopleProfileController *profile = nil;
//        for(UIViewController *vc in [self.navigationController viewControllers])
//            if([vc isKindOfClass:[BanBu_PeopleProfileController class]])
//            {
//                profile = (BanBu_PeopleProfileController *)vc;
//                break;
//            }
//        if(profile)
//        {
//            [self.navigationController popToViewController:profile animated:YES];
//        }
//        else
//        {
//            NSDictionary *proDic = [NSDictionary dictionaryWithDictionary:resDic];
//            
//            profile = [[BanBu_PeopleProfileController alloc] initWithProfile:proDic displayType:DisplayTypePeopleProfile];
//            
//            [self.navigationController pushViewController:profile animated:YES];
//            [profile release];
//        }
//
//        
//        
        BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:resDic displayType:DisplayTypePeopleProfile];
        peopleFfofile.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:peopleFfofile animated:YES];
        [peopleFfofile release];
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Reply_Broadcast]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            //            if([_delegate respondsToSelector:@selector(banBuReplySuccessed)]){
            //                [_delegate banBuReplySuccessed];
            //            }
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];

            [self performSelector:@selector(banBuReplySuccessed) withObject:nil afterDelay:0.5];
            
        }else{
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
        return [dataArr objectAtIndex:selectedImageIndex];
}


#pragma mark - ReplyDelegate

-(void)banBuReplySuccessed{
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
    [pars setValue:[_dynamic valueForKey:@"actid"] forKey:@"actid"];
    [AppComManager getBanBuData:BanBu_Get_Broadcast par:pars delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;


}


-(void)reload{
    [self.tableView reloadData];
}







@end
