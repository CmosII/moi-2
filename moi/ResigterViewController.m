//
//  ResigterViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/26/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "ResigterViewController.h"
#import "htssAppDelegate.h"
#import "RegisterWS.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface ResigterViewController ()
{
    htssAppDelegate *appDelegate;
    RegisterWS *ws;
    
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtVC;
    IBOutlet UITextField *txtPhone;
    IBOutlet UITextField *txtPassword;
}
@end

@implementation ResigterViewController

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
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
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

- (IBAction)btnSMSClicked:(id)sender {
    NSLog(@"btnSMSClicked");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"طلب رمز التعريف"
                                                   message:@"سيتم ارسال رمز التعريف الخاص بك عبر رسالة نصية ... الرجاء التأكد من تسجيل الهاتف في رقمي هويتي"
                                                  delegate:nil
                                         cancelButtonTitle:@"حسناً"
                                         otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnRegister:(id)sender {
    NSLog(@"btnRegister Clicked!");
    ws = [[RegisterWS alloc]init];
    [ws RegisterUserName:txtUserName.text
                Password:txtPassword.text
        VerificationCode:txtVC.text
             PhoneNumber:txtPhone.text];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end