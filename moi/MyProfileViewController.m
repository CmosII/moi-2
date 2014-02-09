//
//  MyProfileViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/23/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

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
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
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

- (IBAction)btnFamilyClicked:(id)sender {
    //[self performSegueWithIdentifier:@"FamilyBookPush" sender:self];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"الخدمة غير متواجدة"
                                                   message:@"عفواً هذه الخدمة غير متوفرة حالياً"
                                                  delegate:nil
                                         cancelButtonTitle:@"العودة"
                                         otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnDomesticsClicked:(id)sender {
    [self performSegueWithIdentifier:@"DomesticsListPush" sender:self];
}

@end
