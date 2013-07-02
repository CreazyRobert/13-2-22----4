//
//  BanBu_SmileLabel.h
//  BanBu
//
//  Created by 来国 郑 on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_SmileLabel : UIView

@property(nonatomic, retain)NSString *text;

+ (float)heightForText:(NSString *)text;

@end
