//
//  BanBu_ViewController.m
//  BanBu
//
//  Created by apple on 12-11-20.
//
//

#import "BanBu_ViewController.h"
#import "BanBu_ChatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BanBu_NoticeView.h"
#import "BanBu_ChatCell.h"
#import "BanBu_MaskView.h"
#import "BanBu_PeopleProfileController.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "AppDataManager.h"
#define InputViewDefaultHeight 28.0
#define InputBarY 372.0

@interface BanBu_ViewController ()
- (void)tableViewAutoOffset;

- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime;

@end

@implementation BanBu_ViewController
@synthesize tableView = _tableView;

@synthesize lat=_lat,lon=_lon;

-(void)menuShow:(UIView *)sender tableCell:(BanBu_ChatCell *)sendert{
    
}

- (id)initWithPeopleProfile:(NSDictionary *)profile
{
    self = [super init];
    if (self) {
        
        
        self.profile = profile;
        MyAppDataManager.chatuid = [profile valueForKey:KeyFromUid];
        
        self.title = [MyAppDataManager IsMinGanWord:VALUE(KeyUname, _profile)];
//        self.title = [NSString stringWithFormat:@"与%@对话",VALUE(KeyUname, _profile)];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
   
     MyAppDataManager.appViewController=self;
    
    [MyAppDataManager.ballTalk removeAllObjects];
   
    [MyAppDataManager readmoredataforBall:BallDialogs];
   
    _firstHere = YES;
    
    UIImageView *bkView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bkView.image = [UIImage imageNamed:@"chatbg.png"];
    [self.view addSubview:bkView];
    [bkView release];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 372.0) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(0, 0, 60, 30);
    [profileButton addTarget:self action:@selector(seeProfile:) forControlEvents:UIControlEventTouchUpInside];
    [profileButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [profileButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [profileButton setTitle:@"TA的资料" forState:UIControlStateNormal];
    profileButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *profileItem = [[[UIBarButtonItem alloc] initWithCustomView:profileButton] autorelease];
    self.navigationItem.rightBarButtonItem = profileItem;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imageView.image = [[UIImage imageNamed:@"bottom-bar.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:10.0];
    imageView.userInteractionEnabled = YES;
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.frame = CGRectMake(5.0, 8.0, 28.0, 28.0);
    _plusButton = plusButton;
    [plusButton addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"btn_plus_br.png"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    [imageView addSubview:plusButton];
    
    UIButton *smileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    smileButton.frame = CGRectMake(38, 8.0, 28, 28);
    _smileButton = smileButton;
    [smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
    [smileButton addTarget:self action:@selector(smileAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:smileButton];
    
    UIButton *actionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton = actionsButton;
    actionsButton.frame = CGRectMake(257.0, 8, 58.0, 28);
    [actionsButton setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
    [actionsButton addTarget:self action:@selector(switchVoice:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:actionsButton];
    
    _inputView = [[UITextView alloc] initWithFrame:CGRectMake(70.0, 8.0,185, 28.0)];
    _inputView.delegate = self;
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    _inputView.layer.borderWidth = 1.0;
    _inputView.layer.cornerRadius = 4.0;
    _inputView.textColor = [UIColor darkTextColor];
    _inputView.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:_inputView];
    [_inputView release];
    
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setImage:[UIImage imageNamed:@"btn_voice.png"] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:@"btn_voice_press.png"] forState:UIControlStateSelected];
    [voiceButton setImage:[UIImage imageNamed:@"btn_voice_press.png"] forState:UIControlStateHighlighted];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(record:)];
    [voiceButton addGestureRecognizer:longPress];
    [longPress release];
    voiceButton.frame = CGRectMake(0,0,320, 44);
    
    
    CFCube *cube = [[CFCube alloc] initWithFrame:CGRectMake(0,372,320,44)];
    _inputBar = cube;
    _inputBar.delegate = self;
    cube.visibleContentView = imageView;
    cube.hiddenContentView = voiceButton;
    [imageView release];
    
    [self.view addSubview:_inputBar];
    [cube release];
    
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:4];
    NSArray *images = [NSArray arrayWithObjects:@"btn_gallery.png",@"btn_takepic.png",@"btn_location.png",@"btn_gallery_press.png",@"btn_takepic_press.png",@"btn_location_press.png", nil];
    for(int i=0; i<3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(4.0, 458, 46, 46);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:@"btn_circle.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:3+i]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(actions:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
    }
    
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 34)];
    images = [NSArray arrayWithObjects:@"btn_history.png",@"btn_deletemsg.png",@"btn_report.png",nil];
    float x = 0;
    for(int i=0; i<3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
        button.frame = CGRectMake(x, 0,image.size.width, 34);
        button.tag = i;
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(topBarButtonActions:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:button];
        x += image.size.width;
    }
    _topBar = barView;
    barView.hidden = YES;
    [self.navigationController.view insertSubview:_topBar atIndex:1];
    [barView release];
    
    [_inputBar addObserver:self forKeyPath:@"frame" options:1 context:nil];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:1 context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)seeProfile:(UIButton *)button
{
    BanBu_PeopleProfileController *profile = nil;
    for(UIViewController *vc in [self.navigationController viewControllers])
        if([vc isKindOfClass:[BanBu_PeopleProfileController class]])
        {
            profile = (BanBu_PeopleProfileController *)vc;
            break;
        }
    if(profile)
    {
        [self.navigationController popToViewController:profile animated:YES];
    }
    else
    {
        
        NSDictionary *proDic = [NSDictionary dictionaryWithDictionary:_profile];
        
        //NSLog(@"prodic:%@",proDic);
        
        
        NSData *temp=[[proDic valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:proDic];
        
        [dic setValue:arr forKey:@"facelist"];
   
      
        
        
        
        
          
        profile = [[BanBu_PeopleProfileController alloc] initWithProfile:dic displayType:DisplayTypePeopleProfile];
        [self.navigationController pushViewController:profile animated:YES];
        [profile release];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect rect = [[change objectForKey:@"new"] CGRectValue];
    if([keyPath isEqualToString:@"contentOffset"])
    {
        return;
    }
    
    [self tableViewAutoOffset];
    
    if(rect.origin.y == 372)
    {
        [_actionButton setImage:_actionButton.selected?[UIImage imageNamed:@"btn_voicekey.png"]:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
        
        CGRect frame = _inputView.frame;
        frame.size.height = InputViewDefaultHeight;
        if(_inputView.frame.size.height == frame.size.height)
            return;
        _inputView.frame = frame;
        frame = _inputBar.visibleContentView.frame;
        frame.origin.y = 0;
        frame.size.height = 44;
        _inputBar.visibleContentView.frame = frame;
        
        CGRect rect = _plusButton.frame;
        rect.origin.y = 8.0;
        _plusButton.frame = rect;
        rect = _smileButton.frame;
        rect.origin.y = 8.0;
        _smileButton.frame = rect;
        rect = _actionButton.frame;
        rect.origin.y = 8.0;
        _actionButton.frame = rect;
        
    }
    if(rect.origin.y < 372)
    {
        [_actionButton setImage:[UIImage imageNamed:@"btn_send.png"] forState:UIControlStateNormal];
        
        BanBu_MaskView *maskView = (BanBu_MaskView *)[self.view viewWithTag:MaskViewTag];
        if(maskView == nil)
        {
            maskView = [[BanBu_MaskView alloc] initWithFrame:self.view.bounds];
            maskView.tag = MaskViewTag;
            maskView.delegate = self;
            [maskView setDidTouchedSelector:@selector(tapped:)];
            [self.view addSubview:maskView];
            [self.view bringSubviewToFront:_inputBar];
            [maskView release];
        }
        else
            maskView.hidden = NO;
    }
}


- (void)plusAction:(UIButton *)button
{
    _showMenu = !_showMenu;
    button.selected = !button.selected;
    if(button.selected)
    {
        for(UIButton *btn in _buttons)
        {
            [self.view addSubview:btn];
            CGRect rect = btn.frame;
            rect.origin.y = [self.view convertRect:_actionButton.frame fromView:_inputBar].origin.y;
            btn.frame = rect;
        }
    }
    
    [UIView animateWithDuration:.3 animations:^{
        button.transform = CGAffineTransformMakeRotation(button.selected?M_PI_4:0);
        
        for(int i=0; i<3; i++)
        {
            UIButton *btn = [_buttons objectAtIndex:i];
            CGRect rect = btn.frame;
            float ry = [self.view convertRect:_actionButton.frame fromView:_inputBar].origin.y;
            rect.origin.y = ry - (button.selected?60:10);
            rect.origin.x = button.selected?4+i*50:0.0;
            btn.frame = rect;
        }
        
    } completion:^(BOOL finished) {
        
        if(!button.selected)
        {
            for(UIButton *btn in _buttons)
                [btn removeFromSuperview];
        }
    }];
}

- (void)smileAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    [button setImage:button.selected?[UIImage imageNamed:@"btn_keyboard.png"]:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
    
    if(_showMenu)
        [self performSelector:@selector(plusAction:) withObject:_plusButton];
    
    if(!button.selected)
    {
        [_inputView becomeFirstResponder];
        return;
    }
    
    if(!_smileView)
    {
        _smileView = [[BanBu_SmileView alloc] initWithFrame:CGRectMake(0, 416, 320, SmileViewDefaultHeight)];
        _smileView.type = SmileViewSmileType;
        _smileView.delegate = self;
        [self.view addSubview:_smileView];
        [_smileView release];
        
        if([_inputView isFirstResponder])
            [_inputView resignFirstResponder];
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         _smileView.frame = CGRectMake(0, 196, 320, SmileViewDefaultHeight);
                         _inputBar.frame = CGRectMake(0, _smileView.frame.origin.y-44.0, 320, 44);
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
                         
                     }];
    
}
- (void)switchVoice:(UIButton *)button
{
    
    if(_inputBar.frame.origin.y < 372)
    {
        [self sendOneMsg:_inputView.text type:ChatCellTypeText filePathExtension:nil];
        _inputView.text = nil;
        
        [self tableViewAutoOffset];
        
        return;
    }
    button.selected = !button.selected;
    [button setImage:button.selected?[UIImage imageNamed:@"btn_voicekey.png"]:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
    
    button.enabled = NO;
    [_inputBar.hiddenContentView addSubview:_plusButton];
    [_inputBar.hiddenContentView addSubview:button];
    if(button.selected)
    {
        [_inputBar flipWithStyle:CFCubeFLipDown];
    }
    else
    {
        [_inputBar flipWithStyle:CFCubeFlipUp];
    }
}

#pragma CFCube delegate method

- (void)cfCubeFlipDidStop:(CFCube *)cfCube
{
    _actionButton.enabled = YES;
}
/**************** end *************/
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [AppComManager stopReceiveBallMsgForUid:MyAppDataManager.chatuid];
    
    [AppComManager cancalHandlesForObject:self];
    
   
    [AppComManager startReceiveMsg];
    
    
    
    if([_inputView isFirstResponder])
        [_inputView resignFirstResponder];
    
    if(!_topBar.hidden)
    {
        [self showTopBar];
    }
    
    [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!_firstHere)
    {
        [self showTopBar];
        _firstHere = YES;
        BanBu_NoticeView *notice = [[BanBu_NoticeView alloc] initWithFrame:self.navigationController.view.bounds];
        [self.navigationController.view addSubview:notice];
        [notice release];
        
    }
    
    CGFloat offset = self.tableView.contentSize.height-self.tableView.bounds.size.height;
    if(offset<1)
        offset = 0;
    [self.tableView setContentOffset:CGPointMake(0, offset)];
    
    [AppComManager.receiveMsgTimer invalidate];
    
//    [AppComManager startReceiveBallMsgFromUid:MyAppDataManager.chatuid forDelegate:MyAppDataManager];
    
    
}

- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime
{
    if(!ltime || !stime)
        return NO;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatter dateFromString:stime];
    if(!currentDate)
        return NO;
    NSDate *lastDate = [formatter dateFromString:ltime];
    if(!lastDate)
        return NO;
    
    return [currentDate timeIntervalSince1970]>[lastDate timeIntervalSince1970]+300;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return MyAppDataManager.ballTalk.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *amsg = [MyAppDataManager.ballTalk objectAtIndex:indexPath.row];

    
    return [VALUE(KeyHeight, amsg) floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_ChatCell *cell = (BanBu_ChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[BanBu_ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *amsg;
    if([MyAppDataManager.ballTalk count]!=0)
    {
     
        
        amsg = [MyAppDataManager.ballTalk objectAtIndex:indexPath.row];
        
        
        
    }else
    {
        amsg=nil;
    }
    BOOL me = [VALUE(KeyMe,amsg) boolValue];
    cell.showTime = [VALUE(KeyShowtime, amsg) boolValue];
    cell.atLeft = !me;
    [cell setAvatarImage:VALUE(KeyUface, amsg)];
    
    cell.type = [VALUE(KeyType, amsg) integerValue];
    
    cell.status = [VALUE(KeyStatus, amsg) integerValue];
    cell.delegate=nil;
    if(cell.showTime)
        cell.timeLabel.text = [amsg valueForKey:KeyStime];
    if(cell.type == ChatCellTypeText)
        [cell setSmileLabelText:[amsg valueForKey:KeyContent]];
    else if(cell.type == ChatCellTypeLocation)
    {
        cell.delegate=self;
        NSString *content = [amsg valueForKey:KeyContent];
        CLLocationDegrees lat = CGPointFromString(content).y;
        CLLocationDegrees lon = CGPointFromString(content).x;
        _lat=content;
        
        
        [cell setLocationLat:lat andLong:lon];
    }
    else
    {
        MediaStatus status = [VALUE(KeyMediaStatus, amsg) integerValue];
        NSString *content = VALUE(KeyContent, amsg);
        [cell.mediaView setStatus:status];
        [cell.mediaView setMedia:content];
        
       // cell.mediaView.appChatController=self;
        
        if(status == MediaStatusDownload)
            [AppComManager getBanBuMedia:content forMsgID:[VALUE(KeyID, amsg) integerValue] fromUid:MyAppDataManager.chatuid delegate:MyAppDataManager];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BanBu_ChatCell *cell = (BanBu_ChatCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if(cell)
    {
        if(cell.type==ChatCellTypeImage)
        {
            
            
            
            
        }
        
        
    }
    
    
    
    
}

-(void)MakeBigMap
{
    CLLocationDegrees lat = CGPointFromString(_lat).y;
    CLLocationDegrees lon = CGPointFromString(_lat).x;
    
    
    BanBu_MakeBigMapViewController *BigMap=[[BanBu_MakeBigMapViewController alloc]initWithCGPoint:lat andLon:lon];
    
    
    [BigMap setLocationLat:lat andLong:lon];

    [self.navigationController pushViewController:BigMap animated:YES];
    
    [BigMap release];
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y < 0)
    {
        [self showTopBar];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.tableView.contentInset.top != 0)
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


- (void)keyboardShowNotify:(NSNotification *)notification
{
    //216   252
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if([notification.name isEqualToString:UIKeyboardWillHideNotification])
    {
        if(_smileView)
            keyboardHeight = 216;
        else
            keyboardHeight = 0;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = _inputBar.frame;
                         rect.origin.y = 372 - keyboardHeight;
                         _inputBar.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         ;                     }
     ];
    
}

#pragma BanBu_SmileView Delegate

- (void)banBu_SmileView:(BanBu_SmileView *)smileView didInputSmile:(NSString *)inputString isDelete:(BOOL)del
{
    if(del)
    {
        if([_inputView hasText])
        {
            if(smileView.inputedStr.count)
            {
                NSInteger deleteLength = [[smileView.inputedStr lastObject] length];
                _inputView.text = [_inputView.text stringByReplacingCharactersInRange:NSMakeRange(_inputView.text.length-deleteLength,deleteLength) withString:@""];
                [smileView.inputedStr removeLastObject];
            }
            else
                _inputView.text = [_inputView.text substringToIndex:_inputView.text.length-1];
            
        }
    }
    else
        _inputView.text = [_inputView.text stringByAppendingString:inputString];
    [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
    [_inputView scrollRectToVisible:CGRectMake(0, _inputView.contentSize.height-10, _inputView.contentSize.width, 6) animated:YES];
    
}


#pragma mark UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(_showMenu)
    {
        [self performSelector:@selector(plusAction:) withObject:_plusButton];
    }
    
    if(_smileView)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _smileView.frame = CGRectMake(0, 416, 320, 216);
                             
                         } completion:^(BOOL finished) {
                             
                             [_smileView removeFromSuperview];
                             _smileView = nil;
                         }];
    }
    
    if(_smileButton.selected)
    {
        _smileButton.selected = NO;
        [_smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
    }
    if(textView.text.length)
        [self performSelector:@selector(textViewDidChange:) withObject:textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    float overPass = textView.contentSize.height - InputViewDefaultHeight;
    if(overPass > 60)
        return;
    if(overPass < 7)
        overPass = 0;
    if(textView.frame.size.height == (overPass+InputViewDefaultHeight))
        return;
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             CGRect frame = textView.frame;
                             frame.size.height = overPass+InputViewDefaultHeight;
                             if(textView.frame.size.height == frame.size.height)
                                 return;
                             textView.frame = frame;
                             
                             frame = _inputBar.visibleContentView.frame;
                             frame.origin.y = 0 - overPass;
                             frame.size.height = 44 + overPass;
                             _inputBar.visibleContentView.frame = frame;
                             
                             CGRect rect = _plusButton.frame;
                             rect.origin.y = frame.size.height - 36;
                             _plusButton.frame = rect;
                             rect = _smileButton.frame;
                             rect.origin.y = frame.size.height - 36;
                             _smileButton.frame = rect;
                             rect = _actionButton.frame;
                             rect.origin.y = frame.size.height - 36;
                             _actionButton.frame = rect;
                             
                             
                         }
                         completion:^(BOOL finished) {
                             [textView scrollRangeToVisible:NSMakeRange(textView.text.length-20, 10)];
                             [self tableViewAutoOffset];
                         }];
    }
    
}



- (void)tapped:(BanBu_MaskView *)maskView
{
    maskView.hidden = YES;
    if(_showMenu)
    {
        [self performSelector:@selector(plusAction:) withObject:_plusButton];
    }
    
    if(_smileView)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _smileView.frame = CGRectMake(0, 416, 320, 216);
                             _inputBar.frame = CGRectMake(0, 372, 320, 44);
                             
                         } completion:^(BOOL finished) {
                             
                             [_smileView removeFromSuperview];
                             _smileView = nil;
                             
                             if(_smileButton.selected)
                             {
                                 _smileButton.selected = NO;
                                 [_smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
                             }
                             
                         }];
    }
    
    [_inputView resignFirstResponder];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}


- (void)showTopBar
{
    _topBar.hidden = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = _topBar.frame;
                         rect.origin.y = (rect.origin.y<64?64:30);
                         _topBar.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         if(_topBar.frame.origin.y < 64)
                             _topBar.hidden = YES;
                         else
                         {
                             [self performSelector:@selector(showTopBar) withObject:nil afterDelay:3.0];
                         }
                     }];
    
}

/****************************************/
/*      发送图片、照相、地理位置、声音        */
/****************************************/
- (void)actions:(UIButton *)button
{
    
    if(_showMenu)
        [self performSelector:@selector(plusAction:) withObject:_plusButton];
    
    
    if(button.tag < 2)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if(button.tag == 0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
        }
        else if(button.tag == 1)
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [picker setAllowsEditing:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else
    {
        [self sendOneMsg:nil type:ChatCellTypeLocation filePathExtension:nil];
    }
    
}

#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    NSString *imagePathExtension = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        imagePathExtension = @"jpg";
    else
    {
        imagePathExtension = [[[editingInfo valueForKey:UIImagePickerControllerReferenceURL] pathExtension] lowercaseString];
        if([imagePathExtension isEqualToString:@"gif"])
            imagePathExtension = @"jpg";
    }
    
    NSData *data = nil;
    if([imagePathExtension isEqualToString:@"png"])
        data = UIImagePNGRepresentation(image);
    else
        data = UIImageJPEGRepresentation(image, 1.0);
    
    [self sendOneMsg:data type:ChatCellTypeImage filePathExtension:imagePathExtension];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)record:(UILongPressGestureRecognizer *)longPress
{
    UIButton *button = (UIButton *)longPress.view;
    
    if(button.selected)
    {
        CGPoint point = [longPress locationInView:_recordView];
        if(longPress.state == UIGestureRecognizerStateEnded)
        {
            button.selected = NO;
            [_recordView touchesEndInView:point];
            _recordView = nil;
        }
        else
            [_recordView touchesMovedInView:point];
        
        return;
    }
    
    button.selected = YES;
    RecordView *recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 20, 320, 416)];
    _recordView = recordView;
    NSString *fileName = [NSString stringWithFormat:@"%i-%@.%@",MyAppDataManager.ballTalk.count,MyAppDataManager.chatuid,@"amr"];
    _recordView.audioPath = [AppComManager pathForMedia:fileName];
    recordView.delegate = self;
    [self.navigationController.view addSubview:recordView];
    [recordView release];
    
}

- (void)topBarButtonActions:(UIButton *)button
{
    if(button.tag == 1)
    {
        NSString *t=[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)];
        t=[t stringByAppendingString:@"ball"];
        
        [MyAppDataManager removeTableNamed:t];
        [MyAppDataManager.ballTalk removeAllObjects];
        
        [self.tableView reloadData];
        
    }else if(button.tag==0)
    {
        [MyAppDataManager readMoreDataForCurrentDialog:DefaultReadNum];
        
        [self.tableView reloadData];
        
    }else{
        
        
        
        
    }
    
    
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    

    
    
}




/*************end**************/
/************** chat **************/

- (void)sendOneMsg:(id)MsgData type:(ChatCellType)type filePathExtension:(NSString *)pathExtension
{
    NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithCapacity:2];
    [amsg setValue:[NSNumber numberWithInt:MyAppDataManager.ballTalk.count] forKey:KeyID];
    [amsg setValue:[NSNumber numberWithInt:type] forKey:KeyType];
    [amsg setValue:[NSNumber numberWithBool:YES] forKey:KeyMe];
    [amsg setValue:[NSNumber numberWithInt:ChatStatusSending] forKey:KeyStatus];
    [amsg setValue:MyAppDataManager.userAvatar forKey:KeyUface];
    
    NSInteger row = MyAppDataManager.ballTalk.count;
    
    NSString *lastTimeStr = nil;
    if(row)
        lastTimeStr = [[MyAppDataManager.ballTalk objectAtIndex:row-1] valueForKey:KeyStime];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stime = [formatter stringFromDate:[NSDate date]];
    [amsg setValue:stime forKey:KeyStime];
    BOOL showTime = [self fiveMinuteLater:stime beforeTime:lastTimeStr];
    [amsg setValue:[NSNumber numberWithBool:showTime] forKey:KeyShowtime];
    
    switch (type) {
        case ChatCellTypeText:
        {
            
            if([MsgData length]==0)
            {
                return;
                
            }
            
            [amsg setValue:MsgData forKey:KeyContent];
            [amsg setValue:[NSNumber numberWithFloat:[BanBu_SmileLabel heightForText:MsgData]+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
            break;
        }
        case ChatCellTypeLocation:
        {
            
            
            [amsg setValue:NSStringFromCGPoint(CGPointMake(AppLocationManager.curLocation.longitude, AppLocationManager.curLocation.latitude)) forKey:KeyContent];
            
            
            [amsg setValue:[NSNumber numberWithFloat:locationTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
            break;
        }
        case ChatCellTypeImage:
        {
            NSString *fileName = [NSString stringWithFormat:@"%i-%@.%@",MyAppDataManager.ballTalk.count,MyAppDataManager.chatuid,pathExtension];
            [amsg setValue:fileName  forKey:KeyContent];
            [amsg setValue:[NSNumber numberWithFloat:ImageTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusUpload] forKey:KeyMediaStatus];
            
            break;
        }
        case ChatCellTypeVoice:
        {
            NSString *fileName = [NSString stringWithFormat:@"%i-%@.%@",MyAppDataManager.ballTalk.count,MyAppDataManager.chatuid,pathExtension];
            [amsg setValue:fileName forKey:KeyContent];
            [amsg setValue:[NSNumber numberWithFloat:VoiceTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusUpload] forKey:KeyMediaStatus];
            
            break;
        }
        default:
            break;
    }
    [MyAppDataManager.ballTalk addObject:amsg];
    
    // 把对话插入到数据库当中去
    
    [MyAppDataManager insertData:amsg forItem:BallDialogs forUid:MyAppDataManager.chatuid];
    
    NSMutableDictionary *aNewDialog = [NSMutableDictionary dictionaryWithDictionary:_profile];
    [aNewDialog setValue:VALUE(KeyContent, amsg) forKey:KeyLasttalk];
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",nil];
    
    [aNewDialog setValue:[mapArr objectAtIndex:type] forKey:KeyType];
    [aNewDialog setValue:VALUE(KeyStime, amsg) forKey:KeyStime];
    
    // 转换头像
    
    NSData *temp=[[aNewDialog valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
    
       
    [aNewDialog setValue:arr forKey:@"facelist"];

    
    
    
    
    
    
    
    // 更新对话列表***********************
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray: VALUE(@"facelist", aNewDialog)];
    
    [aNewDialog setValue:jsonfrom forKey:@"facelist"];
    
    [MyAppDataManager updateDialogeListWithSendMsg:aNewDialog forUid:VALUE(KeyFromUid, aNewDialog) Item:BallDialogs];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:MyAppDataManager.ballTalk.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self tableViewAutoOffset];
    
    if(type==ChatCellTypeText || type==ChatCellTypeLocation)
    {
        [MyAppDataManager sendTextBall:VALUE(KeyContent, amsg) forType:type toUid:MyAppDataManager.chatuid];
    }
    else
    {
        NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [sendDic setValue:pathExtension forKey:@"extname"];
        [sendDic setValue:MyAppDataManager.chatuid forKey:KeyUid];
        [AppComManager uploadBanBuMedia:MsgData
                              mediaName:VALUE(KeyContent, amsg)
                                    par:sendDic
                               delegate:MyAppDataManager];
    }
}


/************** chat **************/

#pragma recordView delegate method

- (void)recordView:(RecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration
{
    [self sendOneMsg:audioData type:ChatCellTypeVoice filePathExtension:@"amr"];
}
- (void)tableViewAutoOffset
{
    CGRect rect = _inputBar.frame;
    NSInteger cellNum = MyAppDataManager.ballTalk.count;
    if(cellNum)
    {
        float offset = self.tableView.contentSize.height -rect.origin.y + 24;
        if(offset<0)
            offset = 0;
        [UIView animateWithDuration:0.6 animations:^{
            [self.tableView setContentInset:UIEdgeInsetsMake(-offset, 0, 0, 0)];
            
        }];
    }
}

- (void)dealloc
{
    MyAppDataManager.appChatController = nil;
    
    [_inputBar removeObserver:self forKeyPath:@"frame"];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [_topBar removeFromSuperview];
    _topBar = nil;
    
    [_buttons release];
    [_tableView release];
    _inputBar = nil;
    [_profile release];
    
    [super dealloc];
    
}

@end
