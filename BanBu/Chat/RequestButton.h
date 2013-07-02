//
//  RequestButton.h
//  BanBu
//
//  Created by apple on 13-2-2.
//
//

#import <UIKit/UIKit.h>

@interface RequestButton : UIButton
{


}
@property(nonatomic,retain)UIActivityIndicatorView *activityd;
@property(nonatomic,assign)BOOL isFridends;
@property(nonatomic,assign)BOOL isActivity;

+(RequestButton *)ButtonWithName:(NSString *)name;

-(id)initWithName:(NSString *)name ;

-(void)upDateActivity;


@end
