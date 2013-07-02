//
//  BanBu_MakeBigMapViewController.m
//  BanBu
//
//  Created by apple on 12-11-13.
//
//

#import "BanBu_MakeBigMapViewController.h"
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"
@interface BanBu_MakeBigMapViewController ()

@end

@implementation BanBu_MakeBigMapViewController
@synthesize lat=_lat,lon=_lon;
@synthesize mapView=_mapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCGPoint:(float)lat andLon:(float)lon;
{
    self=[super init];
    if(self)
    {
        _lat=lat;
        _lon=lon;
    
       self.title=NSLocalizedString(@"makebigTitle", nil);
        
        
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_lat, _lon);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:region animated:NO];
    
    SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:coordinate];
//    annotation.title = @"  ";
//    annotation.subtitle = @"   ";
    [self.mapView addAnnotation:annotation];
}

- (void)setLocationLat:(CLLocationDegrees)lat andLong:(CLLocationDegrees)lon
{
    
    if(!self.mapView)
    {
        self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height)] autorelease];
        
        
        _mapView.frame = CGRectMake(0, 0, 320, __MainScreen_Height);
        
        _mapView.userInteractionEnabled = YES;
        
        
    }
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;

    _mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lon), MKCoordinateSpanMake(0.02, 0.02));
    
    
    [self.view addSubview:_mapView];
    
    [self.view bringSubviewToFront:_mapView];
    
    [_mapView release];
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[SVAnnotation class]]) {
        static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(pulsingView == nil) {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            pulsingView.canShowCallout = YES;
        }
		
		return pulsingView;
    }
    
    return nil;
}

//- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    MKPinAnnotationView *pinView = nil;
//    
//    static NSString *defaultPinID = @"com.halfeet.halfeet";
//    pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//    if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
//                                      initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
//    pinView.pinColor = MKPinAnnotationColorRed;
//    pinView.canShowCallout = YES;
//    pinView.animatesDrop = YES;
//    [_mapView.userLocation setTitle:@"欧陆经典"];
//    [_mapView.userLocation setSubtitle:@"vsp"];
//    return pinView;
//}


-(void)dealloc
{
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
