//
//  BanBu_IceTextCell.h
//  BanBu
//
//  Created by Jc Zhang on 12-12-12.
//
//

#import <UIKit/UIKit.h>

@interface BanBu_IceTextCell : UIView{
    UILabel *_saytextLabel;
    UILabel *_extendLabel;
    UIView * _lineView;
}


@property(nonatomic,retain) NSString * saytextStr;
@property(nonatomic,retain) NSString * extendStr;
@end
