/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageDownloaderDelegate.h"
#import "SDWebImageManagerDelegate.h"
#import "SDImageCacheDelegate.h"

@class UIImageView;

typedef enum
{
    SDWebImageRetryFailed = 1 << 0,
    SDWebImageLowPriority = 1 << 1,
    SDWebImageCacheMemoryOnly = 1 << 2
} SDWebImageOptions;

@protocol SDWebImageManagerObsever;

@interface SDWebImageManager : NSObject <SDWebImageDownloaderDelegate, SDImageCacheDelegate>
{
    NSMutableArray *downloadDelegates;
    NSMutableArray *downloaders;
    NSMutableArray *cacheDelegates;
    NSMutableArray *cacheURLs;
    NSMutableDictionary *downloaderForURL;
    NSMutableArray *failedURLs;
    
    /////////
    NSMutableDictionary *cornerRadius;
    
    id<SDWebImageManagerObsever> obsever;
}

@property(nonatomic, assign) id<SDWebImageManagerObsever> obsever;

+ (id)sharedManager;
- (UIImage *)imageWithURL:(NSURL *)url;
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate;
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate options:(SDWebImageOptions)options;
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed __attribute__ ((deprecated)); // use options:SDWebImageRetryFailed instead
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority __attribute__ ((deprecated)); // use options:SDWebImageRetryFailed|SDWebImageLowPriority instead
- (void)setCornerRadius:(float)c forImageWithUrlStr:(NSString *)urlStr;


#if NS_BLOCKS_AVAILABLE
- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
#endif
- (void)cancelForDelegate:(id<SDWebImageManagerDelegate>)delegate;
- (void)cancelAllDownloaders;

@end

@protocol SDWebImageManagerObsever <NSObject>
@optional

- (void) sdImageManagerDidLoadImageWithUrl:(NSURL *)url forImageView:(UIImageView *)imageView image:(UIImage *)image fromLocal:(BOOL)loadFromLocal;
- (void) sdImageManagerDidFailLoadImageWithUrl:(NSURL *)url forImageView:(UIImageView *)imageView error:(NSError *)error;

@end
