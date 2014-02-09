//
//  DelegatorViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/28/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "DelegatorViewController.h"
#import "htssAppDelegate.h"

@interface DelegatorViewController ()
{
    htssAppDelegate *appDelegate;
}
@end

@implementation DelegatorViewController
@synthesize sID;

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
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:sID];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
