//
//  BanBu_SelectPlaceController.m
//  BanBu
//
//  Created by mac on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_SelectPlaceController.h"
#import <QuartzCore/QuartzCore.h>

#import "ThrowBallCell.h"

#import "SectionInfo.h"

#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "BanBu_LocationManager.h"
#import "BanBu_ThrowBallController.h"



@interface BanBu_SelectPlaceController ()

@end

@implementation BanBu_SelectPlaceController




#define BackGroundView 1003
#define CityView 1004
#define PlaceView 1005
#define ManualLocationTV 1006

#define HEADER_HEIGHT 45
//#define LOGINID 


-(void)dealloc{
    [indexData release];
    [cityData release];
    [cityField release];
//    [cityView release];
    [placeField release];
    [downView release];
    [tempPlaceStr release];
    [infoArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"labelText" object:nil];
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = NSLocalizedString(@"selectPlaceTitle", nil);
    UILabel *setCityLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
    setCityLabel.text = NSLocalizedString(@"setCityLabel", nil);
    setCityLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:setCityLabel];
    [setCityLabel release];
    UILabel *setPlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 100, 30)];
    setPlaceLabel.text =  NSLocalizedString(@"setPlaceLabel", nil);
    setPlaceLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview: setPlaceLabel];
    [setPlaceLabel release];
    cityField=[[UITextField alloc]initWithFrame:CGRectMake(100, 20, 200, 30)];
    cityField.text = @"";
    cityField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cityField.layer.borderWidth = 1.0;
    cityField.layer.cornerRadius = 4;
    
    [cityField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [cityField addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventEditingDidBegin];
    cityField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cityField];
    UILabel *paddingView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    paddingView.backgroundColor = [UIColor clearColor];
    cityField.leftView = paddingView;
    cityField.leftViewMode = UITextFieldViewModeAlways;
    [paddingView release];
    placeField = [[UITextField alloc]initWithFrame:CGRectMake(100, 70, 200, 30)];
    placeField.text = @"";
    placeField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    placeField.layer.borderWidth = 1.0;
    placeField.layer.cornerRadius = 4;
//    placeField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    placeField.delegate=self;
    placeField.returnKeyType=UIReturnKeyDone;
    [placeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    placeField.backgroundColor = [UIColor clearColor];
    placeField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [self.view addSubview:placeField];
    UILabel *paddingView1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    paddingView.backgroundColor = [UIColor clearColor];
    placeField.leftView = paddingView1;
    placeField.leftViewMode = UITextFieldViewModeAlways;
    [paddingView1 release];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(270, 70, 30, 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    
    
    downView=[[UIView alloc]initWithFrame:CGRectMake(20, 130, 280, 60)];
    [self.view addSubview:downView];
    downView.backgroundColor=[UIColor clearColor];
    throwBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    throwBtn.frame=CGRectMake(85, 10, 110, 40);
    [throwBtn setBackgroundImage:[UIImage imageNamed:@"buttonok.png"] forState:UIControlStateNormal];
    [throwBtn setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    [throwBtn addTarget:self action:@selector(throwAction) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:throwBtn];
    
    /*************数据***************/
    
    indexData =[[NSMutableArray alloc]init];
    cityData = [[NSMutableArray alloc]init];    
    
    NSString*bundleStr=[[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    NSDictionary *diction=[NSDictionary dictionaryWithContentsOfFile:bundleStr];      
    NSArray  *listArr=[[NSArray alloc]initWithArray:[diction  objectForKey:@"list"]];
    for (int i=0; i<[listArr count]; i++) {
        //省
        [indexData addObject:[[listArr objectAtIndex:i]objectForKey:@"province"]];
        //市
        NSString *tempStr=[[listArr objectAtIndex:i]objectForKey:@"citylist"];
        NSArray *tempArr=[tempStr componentsSeparatedByString:@","];
        [cityData addObject:tempArr];
    }
    [listArr release];
    
    //tableview扩展
    infoArray = [[NSMutableArray alloc]init];
    for (NSString *str in indexData) {
        SectionInfo *section =[[SectionInfo alloc]init];
        section.open = NO;
        [infoArray addObject:section];
        [section release];
        
    }
    openSectionIndex=NSNotFound;
    
    //监听选择的省市，返回选择的省市
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityText:) name:@"labelText" object:nil];
    
    
    indexTitle=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"S",@"Y",@"Z", nil];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [placeField resignFirstResponder];
}

//手动定位
-(void)location{
    [placeField resignFirstResponder];
    if(![placeField.text isEqualToString:@""] && ![tempPlaceStr isEqualToString:placeField.text]){
        
        if([provinceStr isEqualToString:@"直辖市"]){
            
            [self requestData:cityStr andTownStr:cityStr andName:placeField.text];
            
        }else{
            [self requestData:provinceStr andTownStr:cityStr andName:placeField.text];
            
        }
        
    }

}

//抛绣球
-(void)throwAction{
    if([placeField.text isEqualToString:@""] ||[cityField.text isEqualToString:@""]){
        UIAlertView *notiAlert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"cityplaceNil", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [notiAlert show];
        [notiAlert release];
        return;
    }
    if(posplat || posplong){
        BanBu_ThrowBallController *throw = [[BanBu_ThrowBallController alloc]init];
//        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:throw animated:YES];
        [throw release];
    }else{
        UIAlertView *pushAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"placeNULL", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [pushAlert show];
        [pushAlert release];
    }
    
    
    
}


//展示省市的tableview
-(void)selectCity{
    [cityField resignFirstResponder];//取消键盘的相应，弹出自定义栏
    //    //文本框有内容则清空
    //    if(provinceTextField.text){
    //        provinceTextField.text=@"";
    //    }
    UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44)];
    aView.backgroundColor=[UIColor blackColor];
    aView.alpha=0.7;
    aView.tag=BackGroundView;
    [self.view addSubview:aView];
    [aView release];
    
    UITableView *tempTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44) style:UITableViewStylePlain];
    tempTable.tag=CityView;
    tempTable.backgroundColor=[UIColor clearColor];
    //    tempTable.separatorColor=[UIColor clearColor];
    tempTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    tempTable.delegate=self;
    tempTable.dataSource=self;
    [self.view addSubview:tempTable];
    [tempTable release];
    if(infoArray ==nil){
        infoArray = [[NSMutableArray alloc]init];
        for (NSString *str in indexData) {
            SectionInfo *section =[[SectionInfo alloc]init];
            section.open = NO;
            [infoArray addObject:section];
            [section release];
            
        }
        openSectionIndex=NSNotFound;
    }
    
}

-(void)placeSelect:(UIButton *)sender{
    
    posplat = [[hotPlace objectAtIndex:sender.tag]objectForKey:@"poslat"];
    posplong = [[hotPlace objectAtIndex:sender.tag]objectForKey:@"poslong"];
    placeField.text=[NSString stringWithFormat:@"%@",sender.titleLabel.text];
    [placeField resignFirstResponder];
    
}

#pragma mark - RequestData
//根据省、市、关键字检索，返回地址列表
-(void)requestData:(NSString *)cityString andTownStr:(NSString *)townString andName:(NSString *)name{
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:cityString forKey:@"province"];
    [parDic setValue:townString forKey:@"city"];
    [parDic setValue:name forKey:@"keyname"];
    [AppComManager getBanBuData:BanBu_Get_AddList par:parDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"huntNotice", nil) activityAnimated:YES];
    
}

//返回热点
-(void)requestData:(NSString *)cityString{
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:cityString forKey:@"city"];
    [AppComManager getBanBuData:BanBu_Get_CBD par:parDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"huntNotice", nil) activityAnimated:YES];
    
}


#pragma mark - listenr

//监听选择的市，并返回省市名称
-(void)cityText:(NSNotification *)sender{
    int sec=[[[sender userInfo] objectForKey:@"btnSection"]intValue];
    provinceStr=[indexData objectAtIndex:sec];
    cityStr=[sender object];
    cityField.text= [NSString stringWithFormat:@"%@|%@",provinceStr,cityStr];
    
    [infoArray removeAllObjects];
    infoArray=nil;
    [[self.view viewWithTag:CityView] removeFromSuperview];
    [[self.view viewWithTag:BackGroundView] removeFromSuperview];
    
    
    
    //请求热点地区
    
    [self requestData:cityStr];
    
    if(cityView){
        buttonLength = 0;
        lineHeight = 0;
        [[self.view viewWithTag:PlaceView] removeFromSuperview];
        
        
    }
    downView.frame=CGRectMake(10, 130+lineHeight, 280, 60);
    placeField.text=@"";
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView==[self.view viewWithTag:CityView]){
        
        SectionInfo *sectionInfo =[infoArray objectAtIndex:section];
        
        return sectionInfo.open? 1:0;
    }
    return [placeData count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==[self.view viewWithTag:CityView]){
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView==[self.view viewWithTag:CityView]){
        
        return 45;
        
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        
    }
    
    if(tableView==[self.view viewWithTag:ManualLocationTV]){
        
        cell.textLabel.text=[[placeData objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.textLabel.textColor=[UIColor whiteColor];
        
    }
    
    if(tableView==[self.view viewWithTag:CityView]){
        
        for (UIView  * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIView class]]) {
                [view removeFromSuperview];
            }
        }
        
        ThrowBallCell *aThrow= [[ThrowBallCell alloc]initWithFrame:CGRectZero];
        [cell.contentView addSubview:aThrow];
        aThrow.titles=[cityData objectAtIndex:indexPath.section];
        aThrow.btnSection=indexPath.section;
        cell.frame=aThrow.frame;
        [aThrow release];
        
    }
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==[self.view viewWithTag:CityView]){
        return [indexData count];
    }
    return 1;
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(tableView==[self.view viewWithTag:CityView]){
        return indexTitle;
    }
    return nil;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if(tableView==[self.view viewWithTag:CityView]){
//        return [indexData objectAtIndex:section];
//    }
//    return @"请选择：";
// 
//}

#pragma mark - TableViewDelegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView==[self.view viewWithTag:CityView]){
        
        SectionInfo *sectionInfo = [infoArray objectAtIndex:section];
        sectionInfo.headerView = [[[SectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT) title:[indexData objectAtIndex:section] section:section delegate:self]autorelease];
        return sectionInfo.headerView ;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==[self.view viewWithTag:ManualLocationTV]){
        
        [[self.view viewWithTag:ManualLocationTV] removeFromSuperview];
        [[self.view viewWithTag:BackGroundView] removeFromSuperview];
        posplat = [[placeData objectAtIndex:indexPath.row]objectForKey:@"plat"];
        posplong = [[placeData objectAtIndex:indexPath.row]objectForKey:@"plong"];
        placeField.text=[[placeData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
}

#pragma mark - TextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempPlaceStr= [[NSString alloc]initWithString:placeField.text];
    
    cityField.userInteractionEnabled=NO;
    throwBtn.userInteractionEnabled = NO;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    cityField.userInteractionEnabled=YES;
    throwBtn.userInteractionEnabled = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == placeField){
        if(![placeField.text isEqualToString:@""] && ![tempPlaceStr isEqualToString:placeField.text]){
            
            if([provinceStr isEqualToString:@"直辖市"]){
                
                [self requestData:cityStr andTownStr:cityStr andName:placeField.text];
                
            }else{
                [self requestData:provinceStr andTownStr:cityStr andName:placeField.text];
                
            }
            
        }

    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SectionHeaderViewDelegate
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened{
    
    SectionInfo *section=[infoArray objectAtIndex:sectionOpened];
    section.open = YES;
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:0 inSection:sectionOpened]];
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [infoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:previousOpenSectionIndex]];
        
    }
    
    
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    
    [(UITableView*)[self.view viewWithTag:CityView] beginUpdates];
    [(UITableView*)[self.view viewWithTag:CityView]insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [(UITableView*)[self.view viewWithTag:CityView] deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [(UITableView*)[self.view viewWithTag:CityView] endUpdates];
    [indexPathsToInsert release];
    [indexPathsToDelete release];
    openSectionIndex = sectionOpened;
    
    
}

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed{
    
    SectionInfo *section=[infoArray objectAtIndex:sectionClosed];
    section.open =NO;
    
    NSInteger countOfRowsToDelete = [(UITableView*)[self.view viewWithTag:CityView] numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [(UITableView*)[self.view viewWithTag:CityView] deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    openSectionIndex = NSNotFound;
}

#pragma mark - BanBuRequest

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    if(error){
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        
        return;
        
    }
    
    //NSLog(@"%@",resDic);
    if([[resDic objectForKey:@"list"] isEqual:@""]){
        return;
    }
    if([[resDic valueForKey:@"ok"]boolValue]){
        if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_CBD]){
            
            hotPlace=[[NSArray alloc]init];
            hotPlace=[[resDic objectForKey:@"list"]retain];
            
            if(cityView){
                buttonLength = 0;
                lineHeight = 0;
                [[self.view viewWithTag:PlaceView] removeFromSuperview];
            }
            cityView=[[[UIView alloc]initWithFrame:CGRectZero]autorelease];
            cityView.tag=PlaceView;
            cityView.backgroundColor=[UIColor clearColor];
            [self.view addSubview:cityView];
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -10, 280, 1)];
            lineLabel.backgroundColor = [UIColor colorWithRed:208.0/255 green:201.0/255 blue:184.0/255 alpha:1.0];
            [cityView addSubview:lineLabel];
            [lineLabel release];
            
            UILabel *tuijianLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
            tuijianLabel.text = [NSString stringWithFormat:@"> %@",NSLocalizedString(@"hotPlaces", nil)];
            tuijianLabel.font = [UIFont boldSystemFontOfSize:20];
            tuijianLabel.textColor =[UIColor colorWithRed:255.0/255 green:138.0/255 blue:45.0/255 alpha:1.0];
            tuijianLabel.textAlignment = UITextAlignmentLeft;
            tuijianLabel.backgroundColor=[UIColor clearColor];
            [cityView addSubview:tuijianLabel];
            [tuijianLabel release];
            lineHeight+=tuijianLabel.frame.size.height+5;
            for (int i=0; i<[hotPlace count]; i++) {
                NSString *placeStr=[[hotPlace objectAtIndex:i]objectForKey:@"pname"];
                CGSize buttonSize=[placeStr sizeWithFont:[UIFont systemFontOfSize:18]];
                
                UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
                aButton.tag=i;
                if(buttonLength>280-buttonSize.width-5){
                    buttonLength = 0;
                    lineHeight+=30;
                    aButton.frame=CGRectMake(buttonLength, lineHeight, buttonSize.width, 20);
                }else {
                    
                    aButton.frame=CGRectMake(buttonLength, lineHeight, buttonSize.width, 20);
                    
                }
                buttonLength += buttonSize.width+10;
                [aButton setTitle:placeStr forState:UIControlStateNormal];
                [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                aButton.backgroundColor=[UIColor clearColor];
                [cityView addSubview:aButton];
                [aButton addTarget:self action:@selector(placeSelect:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            lineHeight+=25;
            cityView.frame=CGRectMake(20, 125, 280, lineHeight);
            downView.frame=CGRectMake(20, 135+lineHeight, 280, 60);
            
            
        }
        if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_AddList]){
            
            placeData=[[[NSArray alloc]initWithArray:[resDic objectForKey:@"list"]]retain];
            
            if([self.view viewWithTag:BackGroundView] == nil){
                UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height)];
                aView.backgroundColor=[UIColor blackColor];
                aView.alpha=0.7;
                aView.tag=BackGroundView;
                [self.view addSubview:aView];
                [aView release];
            }
            
            
            UITableView *placeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44) style:UITableViewStylePlain];
            placeTable.tag=ManualLocationTV;
            placeTable.backgroundColor=[UIColor clearColor];
            //    tempTable.separatorColor=[UIColor clearColor];
            placeTable.delegate=self;
            placeTable.dataSource=self;
            [self.view addSubview:placeTable];
            [placeTable release];
            
            [placeTable reloadData];
            
        }

    }
    
}

























@end
