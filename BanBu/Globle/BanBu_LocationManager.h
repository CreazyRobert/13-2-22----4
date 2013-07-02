//
//  BanBu_LocationManagerViewController.h
//  BanBu
//
//  Created by 来国 郑 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define AppLocationManager [BanBu_LocationManager sharedLocationManager]

static NSString *const Location = @"Location";

@protocol BanBu_LocationManagerDelegate;

@interface BanBu_LocationManager : UIViewController<CLLocationManagerDelegate,MKReverseGeocoderDelegate>

+ (BanBu_LocationManager *)sharedLocationManager;

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,assign) CLLocationCoordinate2D curLocation;
@property(nonatomic,assign) BOOL getLocation;
@property(nonatomic,assign) BOOL getMyAddress;
@property(nonatomic,assign) id<BanBu_LocationManagerDelegate>delegate;
// 这是代码块

- (void)getMyLocation;
- (void)getCurrentAddress;

@end

@protocol BanBu_LocationManagerDelegate <NSObject>
@optional

- (void)banBu_LocationManager:(BanBu_LocationManager *)manager didGetLocation:(CLLocationCoordinate2D)coordinate success:(BOOL)success;
- (void)banBu_LocationManager:(BanBu_LocationManager *)manager didGetLocationAddr:(NSString *)addr;

-(void)banBu_LocationManager:(BanBu_LocationManager *)manager  didShowIndelegate:(NSString *)addre;


@end
