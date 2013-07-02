//
//  BanBu_RefreshTime.m
//  BanBu
//
//  Created by Jc Zhang on 13-1-30.
//
//

#import "BanBu_RefreshTime.h"

@implementation BanBu_RefreshTime

+(NSString *)getCurrentTime:(NSString *)userDefaultName{
    
 
    //获取当前时间
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeNow = [NSString stringWithString:[dateFormatter stringFromDate:[NSDate date]]];
//    NSLog(@"%@",timeNow);
    if(userDefaultName != nil){
        [[NSUserDefaults standardUserDefaults] setValue:timeNow forKey:userDefaultName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return timeNow;
   
}

+(BOOL)now:(NSString *)timeNow isLaterBefore:(NSString *)beforeTime{
    
    NSDateFormatter *nowFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [nowFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [nowFormatter dateFromString:timeNow];
    
    NSDateFormatter *beforeFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [beforeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beforeDate = [beforeFormatter dateFromString:beforeTime];
    
    int min = [nowDate timeIntervalSinceDate:beforeDate]/60;
//    NSLog(@"%d",min);
    if(min>=3){
        return YES;
    }
    return NO;
    
}


@end
