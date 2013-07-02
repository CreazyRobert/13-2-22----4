//
//  BanBu_FeedbackView.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-18.
//
//

#import "BanBu_FeedbackView.h"
#import "TKLoadingView.h"
#import "BanBuAPis.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
@interface BanBu_FeedbackView ()

@end

@implementation BanBu_FeedbackView

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
    self.navigationItem.title = NSLocalizedString(@"feedBackLabel", nil);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
    //textView.delegate = self;
    _inputView = textView;
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 6.0;
    textView.textColor = [UIColor darkTextColor];
    textView.font = [UIFont systemFontOfSize:16];
//    textView.text = _textContent;
    [self.view addSubview:textView];
    [textView release];
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(49, 165, 218, 40);
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [sendBtn setTitle:NSLocalizedString(@"sendNow", nil) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBrd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputView resignFirstResponder];
}

-(void)sendBrd{
    [_inputView resignFirstResponder];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setObject:_inputView.text forKey:KeyContent];
    NSLog(@"%@",_inputView.text);
    if([_inputView.text length])
    {
            self.view.userInteractionEnabled = NO;
    [AppComManager getBanBuData:Banbu_Send_Feedback par:parDic delegate:self];
    }
    else
    {
        [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(120, 120) title:NSLocalizedString(@"kongAlert", nil)  activityAnimated:NO duration:2.0];
    }

    
    
    
    
    
    
//    if(_inputView.text){
//        [TKLoadingView showTkloadingAddedTo:self.view title:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"submitButton", nil),NSLocalizedString(@"finishToolItem", nil)] activityAnimated:NO duration:2.0];
//
//    }
}
- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.view.userInteractionEnabled = YES;
    if(error)
    {
//        NSLog(@"%@",error);
        if([error.domain isEqualToString:BanBuDataformatError])
        {
//            [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(120, 120) title:NSLocalizedString(@"data_error", nil)  activityAnimated:NO duration:2.0];
        }
        else
        {
//            [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(120, 120) title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        return;
    }
    else
    {
        if([AppComManager respondsDic:resDic isFunctionData:Banbu_Send_Feedback])
        {
            if([[resDic valueForKey:@"ok"]boolValue])
            {
//                [TKLoadingView showTkloadingAddedTo:self.view title:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"submitButton", nil),NSLocalizedString(@"finishToolItem", nil)] activityAnimated:NO duration:2.0];
                [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(120, 120) title:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"submitButton", nil),NSLocalizedString(@"finishToolItem", nil)]  activityAnimated:NO duration:2.0];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(120, 120) title:NSLocalizedString(@"data_error", nil)  activityAnimated:NO duration:2.0];
        }
    }
    

}

@end
