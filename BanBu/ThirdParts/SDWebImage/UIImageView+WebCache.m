/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "RoundRectImage.h"



@implementation UIImageView (WebCache)
int imageType = 0;
//////downloadingSchedule part

- (void)setShowDownloadingSchedule:(BOOL)show;
{
   if(show)
   {
       if([self downloadingScheduleShow])
           return;
       UILabel *scheduleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20.0f)];
       scheduleView.backgroundColor = [UIColor clearColor];
       scheduleView.tag = ScheduleViewTag;
       scheduleView.font = [UIFont boldSystemFontOfSize:15.0f];
       scheduleView.textColor = [UIColor orangeColor];
       scheduleView.textAlignment = UITextAlignmentCenter;
       scheduleView.hidden = YES;
       [scheduleView setCenter:self.center];
       [self addSubview:scheduleView];
       [scheduleView release];
   }
    else 
    {
        [[self scheduleView] removeFromSuperview];
    }
}

- (id)scheduleView
{
    return [self viewWithTag:ScheduleViewTag];
}

- (BOOL)downloadingScheduleShow
{
    return [self scheduleView]?YES:NO;
}

////////////////////////////




- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil andType:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder andType:(int)type
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
    imageType = type;
//    NSLog(@"+++++++++++%d*******%d",type,imageType);
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        UILabel *label = (UILabel *)[self scheduleView];
        label.hidden = NO;
        label.frame = CGRectMake(0, (self.bounds.size.height-20)/2, self.bounds.size.width, 20.0f);
        //label.text = [NSString stringWithFormat:@"0%%"];
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}


-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url{
    
//    self.image = [RoundRectImage createRoundedRectImage:image size:CGSizeMake(75, 75) cornerRadius:3.0];
//    NSLog(@"-------%d",imageType);
     if(imageType){
        self.image = [RoundRectImage createRoundedRectImage:image size:CGSizeMake(150, 150) cornerRadius:5.0];
    }else{

        self.image = image;
    }
    
    UILabel *label = (UILabel *)[self scheduleView];
    label.hidden = YES;
    label.text = nil;
    
    if([[NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:[NSString stringWithFormat:@"%@",url]]]length]<4){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.layer addAnimation: animation forKey: @"FadeIn"];
    }
 
   
}

@end
