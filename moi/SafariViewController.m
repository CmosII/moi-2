//
//  SafariViewController.m
//  moi
//
//  Created by shjmun Mac on 11/11/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "SafariViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "htssAppDelegate.h"
#import "InsertSafariInformationViewController.h"
#import "DelegatorViewController.h"

@interface SafariViewController ()
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    
    IBOutlet UIButton *btnSafariOn;
    IBOutlet UILabel *lblSafariOn;
    IBOutlet UIImageView *imgSafariOn;
    IBOutlet UIButton *btnSafariOff;
    IBOutlet UILabel *lblSafariOff;
    IBOutlet UIImageView *imgSafariOff;
    IBOutlet UIButton *btnEditSafari;
    IBOutlet UIImageView *imgEditSafari;
    IBOutlet UILabel *lblEditSafari;
    
    IBOutlet UIView *viewButtons;
    
    int clickedBtn;
}
@end

@implementation SafariViewController
@synthesize btnMenu;

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
    [viewButtons addGestureRecognizer:self.slidingViewController.panGesture];
//    self.btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnMenu.frame = CGRectMake(8, 68, 34, 24);
//    [btnMenu setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
//    [btnMenu addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
//    //self.navigationItem.leftBarButtonItem = btnMenu;
//    [self.view addSubview:self.btnMenu];
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (appDelegate.isSafariOn) {
        [self editGroupLabel:lblSafariOn Image:imgSafariOn Button:btnSafariOn Status:YES];
        [self editGroupLabel:lblSafariOff Image:imgSafariOff Button:btnSafariOff Status:NO];
        [self editGroupLabel:lblEditSafari Image:imgEditSafari Button:btnEditSafari Status:NO];
        viewButtons.hidden = NO;
    }else{
        [self editGroupLabel:lblSafariOn Image:imgSafariOn Button:btnSafariOn Status:NO];
        [self editGroupLabel:lblSafariOff Image:imgSafariOff Button:btnSafariOff Status:YES];
        [self editGroupLabel:lblEditSafari Image:imgEditSafari Button:btnEditSafari Status:YES];
        viewButtons.hidden = YES;
    }
}

-(void)editGroupLabel:(UILabel*)lbl
                Image:(UIImageView*)img
               Button:(UIButton*)btn
               Status:(BOOL)status
{
    lbl.hidden = status;
    img.hidden = status;
    btn.hidden = status;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSoSClicked:(id)sender {
    clickedBtn = 0;
    [self performSegueWithIdentifier:@"sFollow" sender:self];
}

- (IBAction)btnFollowClicked:(id)sender {
    clickedBtn = 1;
    [self performSegueWithIdentifier:@"sFollow" sender:self];
}

#pragma mark -
#pragma mark Segue Delegates

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sFollow"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        if (clickedBtn == 0) {
            viewController.sID = @"أغثني";
        }else if(clickedBtn == 1){
            viewController.sID = @"تتبعني";
        }
    }
}

#pragma mark - htss methods

- (IBAction)turnOnClicked:(id)sender {
    [self performSegueWithIdentifier:@"ToInsertSafari" sender:self];
}

- (IBAction)turnOffClicked:(id)sender {
    appDelegate.isSafariOn = NO;
    [defaults setBool:appDelegate.isSafariOn forKey:@"isSafariOn"];
    [defaults synchronize];
    [self closeSafariAlerts];
    [self editGroupLabel:lblSafariOn Image:imgSafariOn Button:btnSafariOn Status:NO];
    [self editGroupLabel:lblSafariOff Image:imgSafariOff Button:btnSafariOff Status:YES];
    [self editGroupLabel:lblEditSafari Image:imgEditSafari Button:btnEditSafari Status:YES];
    viewButtons.hidden = YES;
    appDelegate.safariNotification = nil;
}

-(void)closeSafariAlerts
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if ([oldNotifications count] > 0) {
        [app cancelAllLocalNotifications];
    }
}

@end