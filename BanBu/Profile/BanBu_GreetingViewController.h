//
//  BanBu_GreetingViewController.h
//  BanBu
//
//  Created by Jc Zhang on 13-1-23.
//
//

#import <UIKit/UIKit.h>

@interface BanBu_GreetingViewController : UITableViewController<UITextFieldDelegate>{
    
    UITextField *_greetTextField;
}

@property(nonatomic,retain)NSString * touid;

@end
