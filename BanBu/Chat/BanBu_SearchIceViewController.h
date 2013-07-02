//
//  BanBu_SearchIceViewController.h
//  BanBu
//
//  Created by Jc Zhang on 12-12-29.
//
//

#import <UIKit/UIKit.h>
#import "SVSegmentedControl.h"

@interface BanBu_SearchIceViewController : UIViewController<UITextFieldDelegate>{
    
    SVSegmentedControl *seg;
    UITextField *search;
    
    UIView *hotkeyView;
    CGFloat buttonLength;
    CGFloat lineHeight;
    NSString *langauageStr;


    
    NSMutableArray *hotKeyArr;
}

@end
