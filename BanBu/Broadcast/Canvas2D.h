//
//  Canvas2D.h
//  兔丫丫
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface Canvas2D : UIView{
    NSMutableArray* arrayStrokes;
    NSMutableArray *tempArray;
//    UIColor *currentColor; 
    
}
@property (nonatomic ,retain) NSMutableArray* arrayStrokes; 
@property(retain,nonatomic)UIColor *lineColor;
@property(retain,nonatomic)NSNumber *sizeValue;
@property(nonatomic,retain)NSMutableArray *tempArray;


@end
