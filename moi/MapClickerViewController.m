//
//  MapClickerViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/16/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "MapClickerViewController.h"
#import "htssAppDelegate.h"
#import "AnnotationPoint.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface MapClickerViewController ()
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    
    IBOutlet MKMapView *safariMap;
}
@end

@implementation MapClickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

-(void)viewDidAppear:(BOOL)animated
{
    MKCoordinateRegion region;
	region.span= MKCoordinateSpanMake(2.0,2.0);
    region.center = safariMap.userLocation.location.coordinate;
	
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    [safariMap addGestureRecognizer:lpgr];
    
    [safariMap userLocation];
	[safariMap setRegion:region animated:TRUE];
	[safariMap regionThatFits:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - htss Methods

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Map View Delegates

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
	MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"moiMap"];
	
	@try {
        if (pinView==nil) {
            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"moiMap"];
        }else {
            pinView.annotation = annotation;
        }
        
        if (annotation != mapView.userLocation) {
            //if (annotation.coordinate.longitude == selectedPoint.coordinate.longitude && annotation.coordinate.latitude == selectedPoint.coordinate.latitude) {
            if (YES) {
                pinView.pinColor = MKPinAnnotationColorRed;
            }else{
                pinView.pinColor = MKPinAnnotationColorGreen;
            }
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            UIButton *btnAnn = [UIButton buttonWithType:UIButtonTypeInfoDark];
            pinView.rightCalloutAccessoryView = btnAnn;
        }else{
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@",exception.description);
    }
    @finally {
        
    }
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	appDelegate.selectedSafariCoordLong = view.annotation.coordinate.longitude;
	appDelegate.selectedSafariCoordLat = view.annotation.coordinate.latitude;
    [defaults setDouble:appDelegate.selectedSafariCoordLong forKey:@"selectedSafariCoordLong"];
    [defaults setDouble:appDelegate.selectedSafariCoordLat forKey:@"selectedSafariCoordLat"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleLongPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [gestureRecognizer locationInView:safariMap];
    CLLocationCoordinate2D touchMapCoordinate = [safariMap convertPoint:touchPoint toCoordinateFromView:safariMap];
    
    AnnotationPoint *ann = [[AnnotationPoint alloc]init];
    ann.coordinate = touchMapCoordinate;
    [ann setAnnTitle:@"موقع الرحلة"];
    [ann setAnnSubTitle:@"اضغط هنا للتأكيد"];
    
    [safariMap removeAnnotations:[safariMap annotations]];
    [safariMap userLocation];
    [safariMap addAnnotation:ann];
}

@end
