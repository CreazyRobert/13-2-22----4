//
//  RoundRectImage.m
//  HumanFoot HD
//
//  Created by apple on 11-10-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoundRectImage.h"


@implementation RoundRectImage

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius {
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
    return newImage;
} 

static void addRoundedRectToPath(CGContextRef context,
                                 CGRect rect,
                                 float ovalWidth,
                                 float ovalHeight) {
    
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
#pragma mark change the corner size below...
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)rotateImage:(UIImage *)aImage  

{  
	
	CGImageRef imgRef = aImage.CGImage;  
	
	CGFloat width = CGImageGetWidth(imgRef);  
	
	CGFloat height = CGImageGetHeight(imgRef);  
	
	
	
	CGAffineTransform transform = CGAffineTransformIdentity;  
	
	CGRect bounds = CGRectMake(0, 0, width, height);  
	
	
	
	CGFloat scaleRatio = 1;  
	
	
	
	CGFloat boundHeight;  
	
	UIImageOrientation orient = UIImageOrientationLeft;//aImage.imageOrientation;  
	
	switch(orient)  
	
	{  
			
		case UIImageOrientationUp: //EXIF = 1  
			
			transform = CGAffineTransformIdentity;  
			
			break;  
			
			
			
		case UIImageOrientationUpMirrored: //EXIF = 2  
			
			transform = CGAffineTransformMakeTranslation(width, 0.0);  
			
			transform = CGAffineTransformScale(transform, -1.0, 1.0);  
			
			break;  
			
			
			
		case UIImageOrientationDown: //EXIF = 3  
			
			transform = CGAffineTransformMakeTranslation(width, height);  
			
			transform = CGAffineTransformRotate(transform, M_PI);  
			
			break;  
			
			
			
		case UIImageOrientationDownMirrored: //EXIF = 4  
			
			transform = CGAffineTransformMakeTranslation(0.0, height);  
			
			transform = CGAffineTransformScale(transform, 1.0, -1.0);  
			
			break;  
			
			
			
		case UIImageOrientationLeftMirrored: //EXIF = 5  
			
			boundHeight = bounds.size.height;  
			
			bounds.size.height = bounds.size.width;  
			
			bounds.size.width = boundHeight;  
			
			transform = CGAffineTransformMakeTranslation(height, width);  
			
			transform = CGAffineTransformScale(transform, -1.0, 1.0);  
			
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
			
			break;  
			
			
			
		case UIImageOrientationLeft: //EXIF = 6  
			
			boundHeight = bounds.size.height;  
			
			bounds.size.height = bounds.size.width;  
			
			bounds.size.width = boundHeight;  
			
			transform = CGAffineTransformMakeTranslation(0.0, width);  
			
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
			
			break;  
			
			
			
		case UIImageOrientationRightMirrored: //EXIF = 7  
			
			boundHeight = bounds.size.height;  
			
			bounds.size.height = bounds.size.width;  
			
			bounds.size.width = boundHeight;  
			
			transform = CGAffineTransformMakeScale(-1.0, 1.0);  
			
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
			
			break;  
			
			
			
		case UIImageOrientationRight: //EXIF = 8  
			
			boundHeight = bounds.size.height;  
			
			bounds.size.height = bounds.size.width;  
			
			bounds.size.width = boundHeight;  
			
			transform = CGAffineTransformMakeTranslation(height, 0.0);  
			
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
			
			break;  
			
			
			
		default:  
			
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
			
	}  
	
	
	
	UIGraphicsBeginImageContext(bounds.size);  
	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();  
	
	
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
		
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
		
		CGContextTranslateCTM(context, -height, 0);  
		
	}  
	
	else {  
		
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
		
		CGContextTranslateCTM(context, 0, -height);  
		
	}  
	
	
	
	CGContextConcatCTM(context, transform);  
	
	
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
	
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
	
	UIGraphicsEndImageContext();  
	
	
	
	return imageCopy;  
	
}  

@end
