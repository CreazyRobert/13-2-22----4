//
//  RoundRectImage.h
//  HumanFoot HD
//
//  Created by apple on 11-10-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoundRectImage : NSObject {

}

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius;
static void addRoundedRectToPath(CGContextRef context,
                                 CGRect rect,
                                 float ovalWidth,
                                 float ovalHeight);
+(UIImage *)rotateImage:(UIImage *)aImage;  

@end
