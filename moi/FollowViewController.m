//
//  FollowViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/25/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "FollowViewController.h"
#import "TrackWS.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "htssAppDelegate.h"

@interface FollowViewController ()
{
    htssAppDelegate *appDelegate;
}
@end

@implementation FollowViewController

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
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.locationManager startUpdatingLocation];
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

- (IBAction)btnTrackMeClicked:(id)sender {
    TrackWS *ws = [[TrackWS alloc]init];
    [ws SubmitTrackLog];
}


@end
