//
//  BanBu_RequestCell.h
//  BanBu
//
//  Created by apple on 13-1-29.
//
//

#import "BanBu_ListCell.h"
@class BanBu_RequestViewController;
@class RequestButton;
#import "BanBu_RequestViewController.h"
#import "RequestButton.h"
@interface BanBu_RequestCell : BanBu_ListCell
{
BOOL isFriend;

}
@property(nonatomic,retain)RequestButton *agreeButton;
@property(nonatomic,retain)UIButton *deleteButton;
@property(nonatomic,assign)BanBu_RequestViewController *request;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setButtonName:(NSString *)buttonName Isfriend:(BOOL)friendt;

@end
