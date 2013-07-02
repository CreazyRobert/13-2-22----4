//
//  BanBu_MakeBigMapViewController.h
//  BanBu
//
//  Created by apple on 12-11-13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
@interface BanBu_MakeBigMapViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,assign)float lat;
@property(nonatomic,assign)float lon;
@property(nonatomic, retain)MKMapView *mapView;
-(id)initWithCGPoint:(float)lat andLon:(float)lon;

- (void)setLocationLat:(CLLocationDegrees)lat andLong:(CLLocationDegrees)lon;

@end
