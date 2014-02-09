//
//  SoSSlidesViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/26/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "SoSSlidesViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "htssAppDelegate.h"
#import "SosWS.h"
//@class SosWS;

@interface SoSSlidesViewController ()
{
    htssAppDelegate *appDelegate;
    
    IBOutlet UISlider *slider1;
    IBOutlet UISlider *slider2;
    IBOutlet UISlider *slider3;
    
	IBOutlet UILabel *lbl1;
    IBOutlet UILabel *lbl2;
    IBOutlet UILabel *lbl3;
    
	IBOutlet UIImageView *Container1;
    IBOutlet UIImageView *Container2;
    IBOutlet UIImageView *Container3;
    BOOL UNLOCKED1,UNLOCKED2,UNLOCKED3;
    
    IBOutlet UIView *fbSlideView;
    IBOutlet UIPickerView *categoryPicker;
    NSMutableArray *categoryList;
    SosWS *ws;
}
@end

@implementation SoSSlidesViewController

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
    ws = [[SosWS alloc]init];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [fbSlideView addGestureRecognizer:self.slidingViewController.panGesture];
    
    UNLOCKED1 = NO;
    UNLOCKED2 = NO;
    UNLOCKED3 = NO;
    slider2.enabled = NO;
    slider3.enabled = NO;
    [appDelegate.locationManager startUpdatingLocation];
    categoryList = [NSMutableArray arrayWithObjects:@"إسعاف",@"جريمة",@"حادث سيارة",@"تعطل سيارة",@"أخرى", nil];
    [categoryPicker reloadAllComponents];
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

-(IBAction)UnLockIt1{
    
    if (!UNLOCKED1) {
        
        if (slider1.value ==1.0) {  // if user slide to the most right side, stop the operation
            
            // Put here what happens when it is unlocked
            slider1.hidden = YES;
            
            Container1.hidden = YES;
            
            lbl1.hidden = YES;
            
            UNLOCKED1 = YES;
            slider2.enabled = YES;
        } else {
            
            // user did not slide far enough, so return back to 0 position
            
            [UIView beginAnimations: @"SlideCanceled" context: nil];
            
            [UIView setAnimationDelegate: self];
            
            [UIView setAnimationDuration: 0.35];  
            
            // use CurveEaseOut to create "spring" effect  
            
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];   
            
            slider1.value = 0.0;
            
            lbl1.alpha = 1.0;
            
            [UIView commitAnimations];
        }  
        
    }   
    
}

-(IBAction)fadeLabel1
{
    lbl1.alpha = 1.0 - slider1.value;
}

-(IBAction)UnLockIt2{
    
    if (!UNLOCKED2) {
        
        if (slider2.value ==1.0) {  // if user slide to the most right side, stop the operation
            
            // Put here what happens when it is unlocked
            slider2.hidden = YES;
            
            Container2.hidden = YES;
            
            lbl2.hidden = YES;
            
            UNLOCKED2 = YES;
            slider3.enabled = YES;
        } else {
            
            // user did not slide far enough, so return back to 0 position
            
            [UIView beginAnimations: @"SlideCanceled" context: nil];
            
            [UIView setAnimationDelegate: self];
            
            [UIView setAnimationDuration: 0.35];
            
            // use CurveEaseOut to create "spring" effect
            
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            slider2.value = 0.0;
            
            lbl2.alpha = 1.0;
            
            [UIView commitAnimations];
        }
        
    }
    
}

-(IBAction)fadeLabel2
{
    lbl2.alpha = 1.0 - slider2.value;
}

-(IBAction)UnLockIt3{
    
    if (!UNLOCKED3) {
        
        if (slider3.value ==1.0) {  // if user slide to the most right side, stop the operation
            
            // Put here what happens when it is unlocked
            slider3.hidden = YES;
            
            Container3.hidden = YES;
            
            lbl3.hidden = YES;
            
            UNLOCKED3 = YES;
            
            [self initiateSoS];
            
        } else {
            
            // user did not slide far enough, so return back to 0 position
            
            [UIView beginAnimations: @"SlideCanceled" context: nil];
            
            [UIView setAnimationDelegate: self];
            
            [UIView setAnimationDuration: 0.35];
            
            // use CurveEaseOut to create "spring" effect
            
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            slider3.value = 0.0;
            
            lbl3.alpha = 1.0;
            
            [UIView commitAnimations];
        }
        
    }
    
}

-(IBAction)fadeLabel3
{
    lbl3.alpha = 1.0 - slider3.value;
}

-(void)initiateSoS
{
    if (appDelegate.isSafariOn) {
        NSLog(@"safariOn");
        [ws requestSoSCategory:[categoryPicker selectedRowInComponent:0] ApplicationID:1 ServiceID:appDelegate.safariID];
    }else{
        NSLog(@"safariOff");
        
        [ws requestSoSCategory:[categoryPicker selectedRowInComponent:0] ApplicationID:0 ServiceID:0];
    }
}

#pragma mark - Picker View Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    int r = 0;
    if (pickerView == categoryPicker) {
        r = categoryList.count;
    }
    return r;
}

#pragma mark - Picker View Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == categoryPicker) {
        return [categoryList objectAtIndex:row];
    }
    return @"";
}


@end
