//
//  BanBu_reConnect.m
//  BanBu
//
//  Created by apple on 12-12-20.
//
//

#import "BanBu_reConnect.h"

@implementation BanBu_reConnect
static BanBu_reConnect *t=nil;


+(BanBu_reConnect *)shareBanBu_reConnect
{
    @synchronized(self){
        if(t == nil){
            
            t = [[[self alloc] init] autorelease];
           
        }
    }
    return t;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (t == nil) {
            t = [super allocWithZone:zone];
            return  t;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}
- (oneway void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}


@end
