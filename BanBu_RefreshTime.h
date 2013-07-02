//
//  BanBu_RefreshTime.h
//  BanBu
//
//  Created by Jc Zhang on 13-1-30.
//
//

#import <Foundation/Foundation.h>

@interface BanBu_RefreshTime : NSObject


+(NSString *)getCurrentTime:(NSString *)userDefaultName;

+(BOOL)now:(NSString *)timeNow isLaterBefore:(NSString *)beforeTime;

@end
