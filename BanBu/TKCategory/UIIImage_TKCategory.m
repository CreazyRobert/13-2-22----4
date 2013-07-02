//
//  UIIImage_TKCategory.m
//  BanBu
//
//  Created by 17xy on 12-9-14.
//
//

#import "UIIImage_TKCategory.h"

@implementation UIImage (UIIImage_TKCategory)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+(UIImage *)imageNamed:(NSString *)name
{

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
    return [UIImage imageWithContentsOfFile:imagePath];
    
}

#pragma clang diagnostic pop



@end
