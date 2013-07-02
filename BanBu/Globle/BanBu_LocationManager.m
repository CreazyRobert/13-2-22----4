//
//  BanBu_LocationManagerViewController.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_LocationManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDataManager.h"

@implementation BanBu_LocationManager

@synthesize locationManager = _locationManager;
@synthesize curLocation = _curLocation;
@synthesize getLocation = _getLocation;
@synthesize getMyAddress = _getMyAddress;
@synthesize delegate = _delegate;


static BanBu_LocationManager *sharedLocationManager = nil;

- (void)initRaysource
{
    if(_locationManager == nil)
        _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled])   
    {  
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0f;
        CGPoint point = CGPointFromString([[NSUserDefaults standardUserDefaults] valueForKey:Location]);
        _curLocation = CLLocationCoordinate2DMake(point.x, point.y);
        if(!_curLocation.latitude){
            NSString *langauage=[[MyAppDataManager  getPreferredLanguage]substringToIndex:2];
            NSLog(@"%@",langauage);
            if([langauage isEqual:@"zh"]){
//                _curLocation = CLLocationCoordinate2DMake(35.188888,136.868888);
              _curLocation = CLLocationCoordinate2DMake(39.909027,116.411475);

//                _curLocation = CLLocationCoordinate2DMake(23.122806,113.296956);

            }

            else if ([langauage isEqual:@"ja"])
            {
                _curLocation = CLLocationCoordinate2DMake(35.678074,139.766005);
            }else
            {
                _curLocation = CLLocationCoordinate2DMake(40.713027,-74.005237);
            }
        }
//           _curLocation = CLLocationCoordinate2DMake(40.147976,116.286313);

//        _curLocation = CLLocationCoordinate2DMake(35.666527,139.747182);
//        _curLocation = CLLocationCoordinate2DMake(40.771275,-73.947170);

        
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc] 
//                              initWithTitle:@"开启定位失败"
//                              message:@"您没有开启定位服务请去设置里面打开定位服务"
//                              delegate:nil
//                              cancelButtonTitle:@"ok"
//                              otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
    }
    
}


- (void)getMyLocation
{
    self.getLocation = YES;
    [_locationManager startUpdatingLocation];
}

- (void)getCurrentAddress
{
    self.getMyAddress = YES;
   // [_locationManager startUpdatingLocation];
}


+ (BanBu_LocationManager *)sharedLocationManager;
{
    @synchronized(self){
        if(sharedLocationManager == nil){
            sharedLocationManager = [[[self alloc] init] autorelease];
            [sharedLocationManager initRaysource];
            // 开启定位服务
            [sharedLocationManager getMyLocation];
            
        }
    }
    return sharedLocationManager;
    
}



+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedLocationManager == nil) {
            sharedLocationManager = [super allocWithZone:zone];
            return  sharedLocationManager;
        }
    }
    return nil;
}

- (void)dealloc
{
    [_locationManager release];
    [super dealloc];
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


#pragma CLLocationManager delegate method
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _curLocation = [newLocation coordinate];
    if(!_curLocation.latitude)
        _curLocation = CLLocationCoordinate2DMake(40.199230,118.331400);
    [[NSUserDefaults standardUserDefaults] setValue:NSStringFromCGPoint(CGPointMake(_curLocation.latitude, _curLocation.longitude)) forKey:Location];
    [manager stopUpdatingLocation];
    if(self.getLocation)
    {
        self.getLocation = NO;
        if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocation:success:)])
            [_delegate banBu_LocationManager:self didGetLocation:_curLocation success:YES];
    }

    if(self.getMyAddress==NO)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:
         ^(NSArray* placemarks, NSError* error){
             self.getMyAddress = NO;
             [geocoder cancelGeocode];
             [geocoder release];
             if(error)
             {
                 if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocationAddr:)])
                     [_delegate banBu_LocationManager:self didGetLocationAddr:nil];
             }
             else
             {
                 MKPlacemark *placemark = [placemarks objectAtIndex:0];
                 if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocationAddr:)])
                     
                     [_delegate banBu_LocationManager:self didGetLocationAddr:[placemark name]];
             }
         }];
        
        
//       MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:_curLocation];
//        geocoder.delegate = self;
//        [geocoder start];
    }
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
    
          if([_delegate respondsToSelector:@selector(banBu_LocationManager:didShowIndelegate:)]&&_delegate)
         
          {
              [_delegate banBu_LocationManager:self didShowIndelegate:@"fuck"];
          
          }
        
        
    }
    
    if(self.getLocation)
    {
        self.getLocation = NO;
        if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocation:success:)])
            [_delegate banBu_LocationManager:self didGetLocation:_curLocation success:NO];
    }

    if(self.getMyAddress)
    {
        self.getMyAddress = NO;
        if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocationAddr:)])
            [_delegate banBu_LocationManager:self didGetLocationAddr:nil];
        
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    [geocoder cancel];
    [geocoder release];
    if(self.getMyAddress)
    {
        self.getMyAddress = NO;
        if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocationAddr:)])
 
            [_delegate banBu_LocationManager:self didGetLocationAddr:nil];
    
    }
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [geocoder cancel];
    [geocoder release];
    if(self.getMyAddress)
    {
        self.getMyAddress = NO;
        if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocationAddr:)])
            [_delegate banBu_LocationManager:self didGetLocationAddr:nil];
    }
}

/*- (void)didFinishLocation
{
    if(self.getLocationPic)
    {
        self.getLocationPic = NO;
        UIGraphicsBeginImageContextWithOptions(_mapView.bounds.size, YES,isRetina?2.0:1.0);
        [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.mapView removeFromSuperview];
        self.mapView = nil;
        if([_delegate respondsToSelector:@selector(banBu_LocationManager:didGetLocationPic:)])
            [_delegate banBu_LocationManager:self didGetLocationPic:image];
    }
    
}*/


@end
