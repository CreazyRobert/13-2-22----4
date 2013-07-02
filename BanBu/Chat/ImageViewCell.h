//
//  ImageViewCell.h
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import "waterFlowCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
@interface ImageViewCell : waterFlowCell
{
    UIImageView *imageView;
    UIImageView *gifImageView;

}
-(void)setImageWithURL:(NSURL *)imageUrl;
-(void)setImage:(UIImage *)image;

-(void)relayoutViews;
-(id)initWithIdentifier:(NSString *)indentifier;

-(void)setImagewithString:(NSString *)image;

@end
