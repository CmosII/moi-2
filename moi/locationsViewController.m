//
//  locationsViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 12/1/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "locationsViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "htssAppDelegate.h"
#import "AnnotationPoint.h"

@interface locationsViewController ()
{
    htssAppDelegate *appDelegate;
    
    NSMutableArray *emiratesList,*sectionNames,*sectionsList,*policeCentersList,*trafficCentersList,*communityPoliceCenters,*socialSupportCenters,*investigationCenters;
    IBOutlet UISwitch *typeSelector;
    IBOutlet UIPickerView *cityPicker;
    IBOutlet UITableView *tblLocations;
    
    IBOutlet UIView *viewTableViewer;
    IBOutlet UIView *viewMapViewer;
    int selectedCity;
    
    
    IBOutlet MKMapView *locationsMapView;
    double lat,lon;
    NSString *navTitle;
}

@end

@implementation locationsViewController

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
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    emiratesList = [NSMutableArray arrayWithObjects:@"أبوظبي",@"الشارقة", nil];
    sectionNames = [NSMutableArray arrayWithObjects:@"مراكز الشرطة",@"المرور و الدوريات",@"الشرطة المجتمعية",@"مراكز الدعم الاجتماعي",@"التحريات و المباحث الجنائية", nil];
    CLLocationCoordinate2D location;
    
    //=================================Police Stations=================================
    location.latitude = 24.464175;
    location.longitude = 54.334377;
    AnnotationPoint *p1 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p1.annTitle = @"الخالدية";
    p1.annSubTitle = @"مراكز الشرطة";
    
    location.latitude = 24.315296;
    location.longitude = 54.611597;
    AnnotationPoint *p2 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p2.annTitle = @"بني ياس";
    p2.annSubTitle = @"مراكز الشرطة";
    
    location.latitude = 25.353191;
    location.longitude = 55.394064;
    AnnotationPoint *p3 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p3.annTitle = @"مركز الغرب";
    p3.annSubTitle = @"مراكز الشرطة";
    
    location.latitude = 25.387021;
    location.longitude = 55.414465;
    AnnotationPoint *p4 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p4.annTitle = @"مركز الحيرة";
    p4.annSubTitle = @"مراكز الشرطة";
    
    policeCentersList = [NSMutableArray arrayWithObjects:p1,p2,p3,p4, nil];
    
    
    //=================================Traffic Stations=================================
    location.latitude = 24.449596;
    location.longitude = 54.391873;
    p1 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p1.annTitle = @"المبنى الرئيسي";
    p1.annSubTitle = @"المرور و الدوريات";
    
    location.latitude = 24.315337;
    location.longitude = 54.611664;
    p2 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p2.annTitle = @"مرور و دوريات المفرق";
    p2.annSubTitle = @"المرور و الدوريات";
    
    location.latitude = 25.357581;
    location.longitude = 55.446657;
    p3 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p3.annTitle = @"المبنى الرئيسي";
    p3.annSubTitle = @"المرور و الدوريات";
    
    location.latitude = 25.337238;
    location.longitude = 55.396349;
    p4 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p4.annTitle = @"مكتب مرور أبو شغارة";
    p4.annSubTitle = @"المرور و الدوريات";
    
    trafficCentersList = [NSMutableArray arrayWithObjects:p1,p2,p3,p4, nil];
    
    /*//=================================Community Stations Stations=================================
    location.longitude = 24.451178;
    location.latitude = 54.394756;
    p1 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p1.annTitle = @"شؤون الشرطة المجتمعية العلاقات الإجتماعية و التوجيه";
    p1.annSubTitle = @"المرور و الدوريات";
    
    location.latitude = 24.315337;
    location.longitude = 54.611664;
    p2 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p2.annTitle = @"مرور و دوريات المفرق";
    p2.annSubTitle = @"المرور و الدوريات";
    
    location.latitude = 25.357581;
    location.longitude = 55.446657;
    p3 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p3.annTitle = @"المبنى الرئيسي";
    p3.annSubTitle = @"المرور و الدوريات";
    
    location.latitude = 25.337238;
    location.longitude = 55.396349;
    p4 = [[AnnotationPoint alloc]initWithCoordinate:location];
    p4.annTitle = @"مكتب مرور أبو شغارة";
    p4.annSubTitle = @"المرور و الدوريات";
    
    trafficCentersList = [NSMutableArray arrayWithObjects:p1,p2,p3,p4, nil];
    //communityPoliceCenters = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    //socialSupportCenters = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    //investigationCenters = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];*/
    
    sectionsList = [NSMutableArray arrayWithObjects:policeCentersList,trafficCentersList, nil];
    
    
    [cityPicker reloadAllComponents];
    [self insertAnnotations];
    [self changeViews];
}

-(void)viewDidAppear:(BOOL)animated
{
    MKCoordinateRegion region;
	region.span= MKCoordinateSpanMake(0.1,0.1);
    region.center = appDelegate.locationManager.location.coordinate; //locationsMapView.userLocation.location.coordinate;
	
    [locationsMapView userLocation];
	[locationsMapView setRegion:region animated:TRUE];
	[locationsMapView regionThatFits:region];
}

-(void)insertAnnotations
{
    [locationsMapView removeAnnotations:[locationsMapView annotations]];
    for (NSMutableArray *rowsList in sectionsList) {
        int x;
        if (selectedCity == 0) {
            x = 0;
        }else {
            x = 2;
        }
        for (int i = x; i < x + 2; i++) {
            [locationsMapView addAnnotation:[rowsList objectAtIndex:i]];
        }
    }
}

-(void)changeViews
{
    if (typeSelector.isOn) {
        viewTableViewer.hidden = YES;
        viewMapViewer.hidden = NO;
    }else{
        viewTableViewer.hidden = NO;
        viewMapViewer.hidden = YES;
    }
}

- (IBAction)typeChanged:(id)sender {
    [self changeViews];
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)performNavigationWithTitle:(NSString*)title
                         Subtitle:(NSString*)subTitle
                     setLongitude:(double)longitude
                      setLatitude:(double)latitude
{
    lon = longitude;
    lat = latitude;
    
    navTitle = [NSString stringWithFormat:@"%@ - %@",title,subTitle];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"تنبيه: أنت على وشك الخروج من هذا البرنامج!"
                                                   message:[NSString stringWithFormat:@"هل تريد تشغيل الملاح إلى:\n%@ , %@",title,subTitle]
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"لا",@"نعم",nil];
    [alert show];
}

#pragma mark - Picker View Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    int r = 0;
    if (pickerView == cityPicker) {
        r = emiratesList.count;
    }
    return r;
}

#pragma mark - Picker View Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == cityPicker) {
        return [emiratesList objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    NSLog(@"selected Row: %i",row);
    if (pickerView == cityPicker) {
        selectedCity = [cityPicker selectedRowInComponent:0];
        [tblLocations reloadData];
        [self insertAnnotations];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [menu count];
    //NSArray *thisArray = [sectionsList objectAtIndex:section];
    return 2; //thisArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 35;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *thisArray = [sectionsList objectAtIndex:indexPath.section];
    NSArray *cityArray;
    if (selectedCity == 0) {
        cityArray = [NSArray arrayWithObjects:[thisArray objectAtIndex:0],[thisArray objectAtIndex:1], nil];
    }else if (selectedCity == 1){
        cityArray = [NSArray arrayWithObjects:[thisArray objectAtIndex:2],[thisArray objectAtIndex:3], nil];
    }
    
    AnnotationPoint *tempP = [cityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",tempP.title];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tempP.subtitle];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionNames objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *thisArray = [sectionsList objectAtIndex:indexPath.section];
    NSArray *cityArray;
    if (selectedCity == 0) {
        cityArray = [NSArray arrayWithObjects:[thisArray objectAtIndex:0],[thisArray objectAtIndex:1], nil];
    }else if (selectedCity == 1){
        cityArray = [NSArray arrayWithObjects:[thisArray objectAtIndex:2],[thisArray objectAtIndex:3], nil];
    }
    
    AnnotationPoint *tempP = [cityArray objectAtIndex:indexPath.row];
    
    [self performNavigationWithTitle:tempP.title Subtitle:tempP.subtitle setLongitude:tempP.coordinate.longitude setLatitude:tempP.coordinate.latitude];
    
    NSLog(@"%i",thisArray.count);
    NSLog(@"Title: %@",tempP.title);
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
            if ([annotation.subtitle isEqualToString:@"مراكز الشرطة"]) {
                pinView.pinColor = MKPinAnnotationColorRed;
            }else if ([annotation.subtitle isEqualToString:@"المرور و الدوريات"]){
                pinView.pinColor = MKPinAnnotationColorPurple;
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
	double selectedLong = view.annotation.coordinate.longitude;
	double selectedLat = view.annotation.coordinate.latitude;
    //popUpView.hidden = NO;
    
    [self performNavigationWithTitle:view.annotation.title Subtitle:view.annotation.subtitle setLongitude:selectedLong setLatitude:selectedLat];
    
}

#pragma mark -
#pragma mark Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f&spn=0.03,0.03&daddr=%f,%f",lat,lon,lat,lon]]];
        
        /*CLLocationCoordinate2D location;
        location.latitude = lat;
        location.longitude = lon;
        MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: location addressDictionary: nil];
        MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = navTitle;
        NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
        NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems: items launchOptions: options];*/
    }
}

@end
