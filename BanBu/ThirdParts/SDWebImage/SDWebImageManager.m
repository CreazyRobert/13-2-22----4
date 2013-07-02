/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import <objc/message.h>
#import "RoundRectImage.h"

#import "UIImageView+WebCache.h"

#if NS_BLOCKS_AVAILABLE
typedef void(^SuccessBlock)(UIImage *image);
typedef void(^FailureBlock)(NSError *error);

@interface SDWebImageManager ()
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;
@end
#endif

static SDWebImageManager *instance;

@implementation SDWebImageManager

@synthesize obsever;

#if NS_BLOCKS_AVAILABLE
@synthesize successBlock;
@synthesize failureBlock;
#endif

- (id)init
{
    if ((self = [super init]))
    {
        downloadDelegates = [[NSMutableArray alloc] init];
        downloaders = [[NSMutableArray alloc] init];
        cacheDelegates = [[NSMutableArray alloc] init];
        cacheURLs = [[NSMutableArray alloc] init];
        downloaderForURL = [[NSMutableDictionary alloc] init];
        failedURLs = [[NSMutableArray alloc] init];
        
        cornerRadius = [[NSMutableDictionary alloc] init];

    }
    return self;
}

- (void)dealloc
{
    obsever = nil;
    SDWISafeRelease(downloadDelegates);
    SDWISafeRelease(downloaders);
    SDWISafeRelease(cacheDelegates);
    SDWISafeRelease(cacheURLs);
    SDWISafeRelease(downloaderForURL);
    SDWISafeRelease(failedURLs);
    SDWISafeRelease(cornerRadius);
    SDWISuperDealoc;
}


+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[SDWebImageManager alloc] init];
    }

    return instance;
}


- (void)setCornerRadius:(float)c forImageWithUrlStr:(NSString *)urlStr
{
    [cornerRadius setValue:[NSNumber numberWithFloat:c] forKey:urlStr];


}

/**
 * @deprecated
 */
- (UIImage *)imageWithURL:(NSURL *)url
{
    return [[SDImageCache sharedImageCache] imageFromKey:[url absoluteString]];
}

/**
 * @deprecated
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed
{
    [self downloadWithURL:url delegate:delegate options:(retryFailed ? SDWebImageRetryFailed : 0)];
}

/**
 * @deprecated
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority
{
    SDWebImageOptions options = 0;
    if (retryFailed) options |= SDWebImageRetryFailed;
    if (lowPriority) options |= SDWebImageLowPriority;
    [self downloadWithURL:url delegate:delegate options:options];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate
{
    [self downloadWithURL:url delegate:delegate options:0];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate options:(SDWebImageOptions)options
{
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class])
    {
        url = [NSURL URLWithString:(NSString *)url];
    }

    if (!url || !delegate || (!(options & SDWebImageRetryFailed) && [failedURLs containsObject:url]))
    {
        return;
    }

    // Check the on-disk cache async so we don't block the main thread
    [cacheDelegates addObject:delegate];
    [cacheURLs addObject:url];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:delegate, @"delegate", url, @"url", [NSNumber numberWithInt:options], @"options", nil];
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:[url absoluteString] delegate:self userInfo:info];
}

#if NS_BLOCKS_AVAILABLE
- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    [self downloadWithURL:url delegate:delegate options:options];
}
#endif

- (void)cancelForDelegate:(id<SDWebImageManagerDelegate>)delegate
{
    NSUInteger idx;
    while ((idx = [cacheDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        [cacheDelegates removeObjectAtIndex:idx];
        [cacheURLs removeObjectAtIndex:idx];
    }

    while ((idx = [downloadDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        SDWebImageDownloader *downloader = SDWIReturnRetained([downloaders objectAtIndex:idx]);

        [downloadDelegates removeObjectAtIndex:idx];
        [downloaders removeObjectAtIndex:idx];

        if (![downloaders containsObject:downloader])
        {
            // No more delegate are waiting for this download, cancel it
            [downloader cancel];
            [downloaderForURL removeObjectForKey:downloader.url];
            
        }

        SDWIRelease(downloader);
    }
}

- (void)cancelAllDownloaders
{
    for(int i=0; i<[cacheDelegates count]; i++)
    {
        id<SDWebImageManagerDelegate> delegate = [cacheDelegates objectAtIndex:i];
        [self cancelForDelegate:delegate];
        i--;
        
    }
}

#pragma mark SDImageCacheDelegate

- (NSUInteger)indexOfDelegate:(id<SDWebImageManagerDelegate>)delegate waitingForURL:(NSURL *)url
{
    // Do a linear search, simple (even if inefficient)
    NSUInteger idx;
    for (idx = 0; idx < [cacheDelegates count]; idx++)
    {
        if ([cacheDelegates objectAtIndex:idx] == delegate && [[cacheURLs objectAtIndex:idx] isEqual:url])
        {
            return idx;
        }
    }
    return NSNotFound;
}

- (void)imageCache:(SDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    [cornerRadius removeObjectForKey:url.absoluteString];

    id<SDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];

    NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }

    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
    {
        [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
    }
    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
    {
        objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, url);
    }
    
    if([obsever respondsToSelector:@selector(sdImageManagerDidLoadImageWithUrl:forImageView:image:fromLocal:)])
    {
        [obsever sdImageManagerDidLoadImageWithUrl:url forImageView:(UIImageView *)delegate image:image fromLocal:YES];
    }

#if NS_BLOCKS_AVAILABLE
    if (self.successBlock)
    {
        self.successBlock(image);
    }
#endif

    [cacheDelegates removeObjectAtIndex:idx];
    [cacheURLs removeObjectAtIndex:idx];
}

- (void)imageCache:(SDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    id<SDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    SDWebImageOptions options = [[info objectForKey:@"options"] intValue];

    NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }

    [cacheDelegates removeObjectAtIndex:idx];
    [cacheURLs removeObjectAtIndex:idx];

    // Share the same downloader for identical URLs so we don't download the same URL several times
    SDWebImageDownloader *downloader = [downloaderForURL objectForKey:url];

    if (!downloader)
    {
        downloader = [SDWebImageDownloader downloaderWithURL:url delegate:self userInfo:info lowPriority:(options & SDWebImageLowPriority)];
        [downloaderForURL setObject:downloader forKey:url];
    }
    else
    {
        // Reuse shared downloader
        downloader.userInfo = info;
        downloader.lowPriority = (options & SDWebImageLowPriority);
    }

    [downloadDelegates addObject:delegate];
    [downloaders addObject:downloader];
}

#pragma mark SDWebImageDownloaderDelegate

- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    SDWIRetain(downloader);
    
 /*   NSString *path = [[NSBundle mainBundle] pathForResource:@"xiazai" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if([data isEqualToData:downloader.imageData])
    {
        path = [[NSBundle mainBundle] pathForResource:@"line" ofType:@"png"];
        downloader.imageData = [NSData dataWithContentsOfFile:path];
        image = [UIImage imageWithContentsOfFile:path];
    }*/
    
    
    SDWebImageOptions options = [[downloader.userInfo objectForKey:@"options"] intValue];
    
    if(image && [[cornerRadius allKeys] containsObject:downloader.url.absoluteString])
    {
        image = [RoundRectImage createRoundedRectImage:image size:image.size cornerRadius:[[cornerRadius objectForKey:downloader.url.absoluteString] floatValue]];
        
        NSData *data = UIImagePNGRepresentation(image);
        if(!data)
            data = UIImageJPEGRepresentation(image, 1.0f);
        downloader.imageData = [NSMutableData dataWithData:data];
        [cornerRadius removeObjectForKey:downloader.url.absoluteString];
    }
    

    BOOL canFindDelegateForDownloader = NO;
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        SDWebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<SDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);

           //  //NSLog(@"12\n");
            
            if (image)
            {
                canFindDelegateForDownloader = YES;

                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
                {
                    objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, downloader.url);
                }
                if([obsever respondsToSelector:@selector(sdImageManagerDidLoadImageWithUrl:forImageView:image:fromLocal:)])
                {
                    [obsever sdImageManagerDidLoadImageWithUrl:downloader.url forImageView:(UIImageView *)delegate image:image fromLocal:NO];
                }
#if NS_BLOCKS_AVAILABLE
                if (self.successBlock)
                {
                    self.successBlock(image);
                }
#endif
            }
            else
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:nil];
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
                {
                    objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, nil, downloader.url);
                }
                if([obsever respondsToSelector:@selector(sdImageManagerDidFailLoadImageWithUrl:forImageView:error:)])
                {
                    [obsever sdImageManagerDidFailLoadImageWithUrl:downloader.url forImageView:(UIImageView *)delegate error:nil];
                }
#if NS_BLOCKS_AVAILABLE
                if (self.failureBlock)
                {
                    self.failureBlock(nil);
                }
#endif
            }

            [downloaders removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
        }
        
    }
    
    if (image)
    {
        [[SDImageCache sharedImageCache] storeImage:image
                                          imageData:downloader.imageData
                                             forKey:[downloader.url absoluteString]
                                             toDisk:!(options & SDWebImageCacheMemoryOnly)];
        if(!canFindDelegateForDownloader)
        {
            if([obsever respondsToSelector:@selector(sdImageManagerDidLoadImageWithUrl:forImageView:image:fromLocal:)])
            {
                [obsever sdImageManagerDidLoadImageWithUrl:downloader.url forImageView:nil image:image fromLocal:NO];
            }
        }
        
    }
    else if (!(options & SDWebImageRetryFailed))
    {
       // //NSLog(@"oofail");
        // The image can't be downloaded from this URL, mark the URL as failed so we won't try and fail again and again
        // (do this only if SDWebImageRetryFailed isn't activated)
        [failedURLs addObject:downloader.url];
    }
    
    // Release the downloader
    [cornerRadius removeObjectForKey:downloader.url.absoluteString];
    [downloaderForURL removeObjectForKey:downloader.url];
    SDWIRelease(downloader);

}

- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error;
{
    SDWIRetain(downloader);

    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        SDWebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<SDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);

            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
            {
                [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:error];
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
            {
                objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, error, downloader.url);
            }
            if([obsever respondsToSelector:@selector(sdImageManagerDidFailLoadImageWithUrl:forImageView:error:)])
            {
                [obsever sdImageManagerDidFailLoadImageWithUrl:downloader.url forImageView:(UIImageView *)delegate error:error];
            }
#if NS_BLOCKS_AVAILABLE
            if (self.failureBlock)
            {
                self.failureBlock(error);
            }
#endif

            [downloaders removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
        }
    }

    // Release the downloader
    [cornerRadius removeObjectForKey:downloader.url.absoluteString];
    [downloaderForURL removeObjectForKey:downloader.url];
    SDWIRelease(downloader);
}

- (void)imageDownloader:(SDWebImageDownloader *)downloader hasDownloadedPercent:(NSNumber *)progress
{
   
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        SDWebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<SDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);
            
            if(![delegate isKindOfClass:[UIImageView class]] || ![(UIImageView *)delegate downloadingScheduleShow])
                return;
            
            if ([delegate respondsToSelector:@selector(webImageManager:didDownloaded:forURL:)])
            {
                objc_msgSend(delegate, @selector(webImageManager:didDownloaded:forURL:), self, progress, downloader.url);
            }
        }
    }
    
}


@end
