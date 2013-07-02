//
//  BanBu_ZibarController.m
//  BanBu
//
//  Created by apple on 12-10-25.
//
//

#import "BanBu_ZibarController.h"
#import "AppCommunicationManager.h"
@interface BanBu_ZibarController ()

@end

@implementation BanBu_ZibarController

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
    
    self.title= NSLocalizedString(@"zibarTitle", nil);
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];

//    //NSLog(@"%@", [UserDefaults objectForKey:@"MyProfile"] );
    
   // self.view.backgroundColor=[UIColor whiteColor];
    
    // 建立名片的view
    
    UIView *cardView=[[UIView alloc]initWithFrame:CGRectMake(25, 20, 270, 360)];
    
    cardView.backgroundColor=[UIColor clearColor];
    cardView.layer.borderWidth =1;
    [self.view addSubview:cardView];
    
    [cardView release];
    
    // 小头像
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    
    headImage.backgroundColor=[UIColor blackColor];
    
    [headImage setImageWithURL:[NSURL URLWithString:MyAppDataManager.userAvatar]];
    
    [cardView addSubview:headImage];
    
    [headImage release];
    
    // 基本资料
    NSDictionary *userinfo = [UserDefaults valueForKey:[NSString stringWithFormat:@"%@",MyAppDataManager.useruid]];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, headImage.frame.origin.y,100 ,35 )];
    nameLabel.text=[MyAppDataManager IsMinGanWord:[MyAppDataManager theRevisedName:[userinfo objectForKey:@"pname"] andUID:[userinfo objectForKey:@"userid"]]];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font=[UIFont boldSystemFontOfSize:14];
    
    [cardView addSubview:nameLabel];
    
    [nameLabel release];
    
    
    UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height, 100, 35)];
     
    NSString *numString=[[NSString alloc]initWithFormat:@"%@%@",NSLocalizedString(@"banbuNum", nil),[userinfo valueForKey:@"userid"]] ;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.text=numString;
    
    numLabel.font=[UIFont systemFontOfSize:12];
    
    [cardView addSubview:numLabel];
    [numString release];
    [numLabel release];
    
    
    // 2 微码
    
    NSMutableDictionary *zibarDic=[[NSMutableDictionary alloc]init];
    
    [zibarDic setValue:@"www.halfeet.com" forKey:@"appsite"];
    
    [zibarDic setValue:@"北京半步移动网络" forKey:@"title"];
    
    // 子字典
    
    NSMutableDictionary *subDic=[[NSMutableDictionary alloc]init];
    
    [subDic setValue:@"get_user_infor" forKey:@"fc"];
    
    [subDic setValue:MyAppDataManager.useruid forKey:@"email_uid"];
    
    
    
    
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:subDic];
//    //NSLog(@"%@",jsonfrom);
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    [subDic release];
    
   
    [zibarDic setValue:jsonfrom forKey:@"code"];
    
    
    jsonfrom = [[CJSONSerializer serializer] serializeDictionary:zibarDic];
    [zibarDic release];
    //NSLog(@"%@",jsonfrom);

    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 200, 200)];
    
    
    imageView.image=[QRCodeGenerator qrImageForString:jsonfrom imageSize:imageView.frame.size.width];
    
    [cardView addSubview:imageView];
    
    [imageView release];
    
    UILabel *descrip=[[UILabel alloc]initWithFrame:CGRectMake(65, 290, 220, 40 )];
    
    descrip.backgroundColor=[UIColor clearColor];
    
    descrip.textColor=[UIColor grayColor];
       
    descrip.text=NSLocalizedString(@"descripLabel", nil);
    
    descrip.font=[UIFont systemFontOfSize:12];
    
    [cardView addSubview:descrip];
    
    [descrip release];
    
    
    
}

// 加上触摸的手势 可以分享


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *touch=[touches anyObject];
    
    CGPoint endPoint=[touch locationInView:self.view];
    
    CGRect rect=CGRectMake(55, 100, 200, 200);
    
    if(CGRectContainsPoint(rect, endPoint))
    {
    
        
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"shareToSina", nil) otherButtonTitles:NSLocalizedString(@"shareToTX", nil), nil ];
        
        
        [sheet showInView:self.view.window];
        
        [sheet release];
        
    
    }
    
    
    
    
    
    
    


}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
 if(buttonIndex==0)
 {
 
     //NSLog(@"0000000");
 
 }else if(buttonIndex==1){
 
     //NSLog(@"11111111111");
     
 
 
 }else{
 
 
     //NSLog(@"what a fuck what a fuck");
 
 }
    
    
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

@end
