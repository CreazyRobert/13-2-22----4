//
//  BanBu_ShareView.h
//  BanBu
//
//  Created by apple on 13-1-21.
//
//

#import <UIKit/UIKit.h>
@class BanBu_ChatViewController;
@interface BanBu_ShareView : UIView
{


}
@property(nonatomic,assign)SEL share;
@property(nonatomic,assign)BanBu_ChatViewController *chat;
@property(nonatomic,assign)int number;
@property(nonatomic,assign)int buttonNumber;
@property(nonatomic,assign)SEL returnArr;
@property(nonatomic,retain)UILabel *headLabel;

-(void)setHeadLabelString:(NSString *)headString;

-(id)initWithController:(BanBu_ChatViewController *)viewController Sel:(SEL)myShare  Tag:(int )number ButtonNum:(int)numbert SelButtonName:(SEL)returnbuttonName;


@end
