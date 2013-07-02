//
//  BanBu_LampText.h
//  BanBu
//
//  Created by Jc Zhang on 12-12-20.
//
//

#import <UIKit/UIKit.h>

@interface BanBu_LampText : UILabel


@property (nonatomic)   float motionWidth;

+(void) showNavTitle:(UIViewController *)controller title:(NSString *)title width:(CGFloat) width;
@end
