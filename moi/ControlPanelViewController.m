//
//  ControlPanelViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/15/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "ControlPanelViewController.h"
#import "htssAppDelegate.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UIImageView+AFNetworking.h"
#import "LogoutViewController.h"

@interface ControlPanelViewController ()
{
    htssAppDelegate *appDelegate;
    
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblNationalID;
    IBOutlet UILabel *lblDoB;
    IBOutlet UILabel *lblSex;
    IBOutlet UILabel *lblNationality;
    IBOutlet UIImageView *imgViewID;
}
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation ControlPanelViewController
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
    NSLog(@"appDelegate.userName: %@",appDelegate.userName);
    NSLog(@"defaults username: %@",[appDelegate.defaults stringForKey:@"userName"]);
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMenu.frame = CGRectMake(8, 10, 34, 24);
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnMenu];
    
    if (appDelegate.userName.length == 0) {
        _btnLogin.hidden = NO;
        _btnLogout.hidden = YES;
        [self performSegueWithIdentifier:@"LoginViewSegue" sender:self];
        lblName.text = @"-";
        lblNationality.text = @"-";
        lblSex.text = @"-";
        lblDoB.text = @"-";
        lblNationalID.text = @"-";
    }else{
        _btnLogin.hidden = YES;
        _btnLogout.hidden = NO;
        lblName.text = appDelegate.aUser.name;
        lblNationality.text = appDelegate.aUser.nationality;
        lblSex.text = appDelegate.aUser.sex;
        lblDoB.text = appDelegate.aUser.dob;
        lblNationalID.text = [NSString stringWithFormat:@"%@xx-xxxxxxx-x",appDelegate.aUser.IDNumber];
        [imgViewID setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://htss.somee.com/images/%@.png",appDelegate.userName]] placeholderImage:[UIImage imageNamed:@"user_blank.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark -
#pragma segue methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"");
    if ([[segue identifier] isEqualToString:@"LogOut"]) {
        appDelegate.userName = @"";
        [appDelegate.defaults setObject:appDelegate.userName forKey:@"userName"];
        [appDelegate.defaults synchronize];
        LogoutViewController *viewController = [segue destinationViewController];
        viewController.isSegueIn = NO;
    }else if ([[segue identifier] isEqualToString:@"LogIn"]) {
        
    }
}

#pragma mark -
#pragma mark htss methods

- (IBAction)logInClicked:(id)sender {
    [self performSegueWithIdentifier:@"LoginViewSegue" sender:self];
}

- (IBAction)logOutClicked:(id)sender {
    if (appDelegate.isSafariOn) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"تنويه"
                                                       message:@"لا يمكن تسجيل الخروج حتى إغلاق رحلة السفاري الحالية"
                                                      delegate:nil
                                             cancelButtonTitle:@"حسناً"
                                             otherButtonTitles:nil];
        [alert show];
    }else{
        NSLog(@"performSegueWithIdentifier: LogOut");
        [self performSegueWithIdentifier:@"LogOut" sender:self];
    }
}

@end
