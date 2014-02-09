//
//  RoadEyesViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/25/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "RoadEyesViewController.h"
#import "htssAppDelegate.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "AnnotationPoint.h"
#import "RoadEyesWS.h"

@interface RoadEyesViewController ()
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    
    IBOutlet UIView *popUpView;
    IBOutlet MKMapView *myMapView;
    
    double selectedLong,selectedLat;
    RoadEyesWS *ws;
}
@end

@implementation RoadEyesViewController

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
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    [appDelegate.locationManager startUpdatingLocation];
    ws = [[RoadEyesWS alloc]init];
	// Do any additional setup after loading the view.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    popUpView.hidden = YES;
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MKCoordinateRegion region;
	region.span= MKCoordinateSpanMake(0.01,0.01);
    region.center = appDelegate.locationManager.location.coordinate; //myMapView.userLocation.location.coordinate;
    
    [myMapView userLocation];
	[myMapView setRegion:region animated:TRUE];
	[myMapView regionThatFits:region];
    
    AnnotationPoint *myPoint = [[AnnotationPoint alloc]initWithCoordinate:appDelegate.locationManager.location.coordinate];
    [myPoint setAnnTitle: @"موقع البلاغ" ];
    [myPoint setAnnSubTitle: @"اضغط هنا للتأكيد" ];
    [myMapView addAnnotation:myPoint];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خدمة عين الطريق"
                                                   message:@"تحرص خدمة عين الطريق توفير وسيلة سهلة للمستخدم للإبلاغ عن أي حالة ازدحام أو أي نوع من العرقلة في الشارع"
                                                  delegate:nil
                                         cancelButtonTitle:@"حسناً"
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            pinView.pinColor = MKPinAnnotationColorRed;
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
	selectedLong = view.annotation.coordinate.longitude;
	selectedLat = view.annotation.coordinate.latitude;
    popUpView.hidden = NO;
}

#pragma mark - htss Methods

- (IBAction)btnClosePopupClicked:(id)sender {
    popUpView.hidden = YES;
}

- (IBAction)btnHighClicked:(id)sender {
    [ws SubmitRoadReportLogLongitude:selectedLong Lattitude:selectedLat ReportType:1];
}

- (IBAction)btnMedClicked:(id)sender {
    [ws SubmitRoadReportLogLongitude:selectedLong Lattitude:selectedLat ReportType:2];
}

- (IBAction)btnLowClicked:(id)sender {
    [ws SubmitRoadReportLogLongitude:selectedLong Lattitude:selectedLat ReportType:3];
}

- (IBAction)btnAccidentClicked:(id)sender {
    [ws SubmitRoadReportLogLongitude:selectedLong Lattitude:selectedLat ReportType:4];
}

- (IBAction)btnHazardClicked:(id)sender {
    [ws SubmitRoadReportLogLongitude:selectedLong Lattitude:selectedLat ReportType:5];
}

@end
