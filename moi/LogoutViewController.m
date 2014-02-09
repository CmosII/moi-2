//
//  LogoutViewController.m
//  moi
//
//  Created by shjmun Mac on 11/12/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "LogoutViewController.h"
#import "htssAppDelegate.h"

@interface LogoutViewController ()
{
    htssAppDelegate *appDelegate;
    
}
@end

@implementation LogoutViewController
@synthesize isSegueIn;

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
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (isSegueIn) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:appDelegate.userCategory forKey:@"userCategory"];
        [defaults setBool:appDelegate.isAR forKey:@"isAR"];
        [defaults synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        //appDelegate.userCategory = nil;
        appDelegate.userCategory = @"tourist";
        appDelegate.aUser.userCategory = @"tourist";
    }
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ControlPanel"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
