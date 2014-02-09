//
//  initViewController.m
//  moi
//
//  Created by shjmun Mac on 11/11/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "initViewController.h"
#import "htssAppDelegate.h"

@interface initViewController ()
{
    htssAppDelegate *appDelegate;
    
    IBOutlet UIButton *btnAR;
    IBOutlet UIButton *btnEN;
    
    UIAlertView *alrtCategory;
    IBOutlet UIImageView *logoImgView;
    
    //IBOutlet UIView *emptyView;
    
    IBOutlet UIView *topEmptyView;
    IBOutlet UIView *bottomEmptyView;
    IBOutlet UIView *emptyView;
}
@end

@implementation initViewController
@synthesize SegueID;

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
    
    //emptyView.hidden = YES;
    emptyView.hidden = NO;
    topEmptyView.hidden = NO;
    bottomEmptyView.hidden = NO;
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
//    defaults = [NSUserDefaults standardUserDefaults];
//    appDelegate.userName = [defaults stringForKey:@"userName"];
//    appDelegate.isAR = [defaults boolForKey:@"isAR"];
//    appDelegate.userCategory = [defaults stringForKey:@"userCategory"];
//    appDelegate.isSafariOn = [defaults boolForKey:@"isSafariOn"];
    
    if (appDelegate.isSafariOn) {
        btnAR.hidden = YES;
        btnEN.hidden = YES;
        logoImgView.hidden = YES;
        emptyView.hidden = YES;
        topEmptyView.hidden = YES;
        bottomEmptyView.hidden = YES;
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"سفاري"];
    }else
    if (appDelegate.userCategory == nil) {
        if ([appDelegate.userCategory isEqualToString:@"local"]) {
            topEmptyView.hidden = YES;
            bottomEmptyView.hidden = YES;
            emptyView.hidden = YES;
            self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"أهلا"];
        }else if ([appDelegate.userCategory isEqualToString:@"resident"]) {
            topEmptyView.hidden = YES;
            bottomEmptyView.hidden = YES;
            emptyView.hidden = YES;
            self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"أهلا"];
        }else{
            NSLog(@"else?");
            //self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"أهلا"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnARClicked:(id)sender {
    appDelegate.isAR = YES;
    
    NSLog(@"appDelegate.aUser.userCategory: %@",appDelegate.aUser.userCategory);
  //if ([appDelegate.aUser.userCategory isEqualToString:@"tourist"]) {
    if ([appDelegate.aUser.userCategory isEqualToString:@"local"]) {
        topEmptyView.hidden = YES;
        bottomEmptyView.hidden = YES;
        emptyView.hidden = YES;
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"الصفحة الرئيسية"];
    }else{
        alrtCategory = [[UIAlertView alloc]initWithTitle:@"مرحبا"
                                                 message:@"تطبيق بلادي يرحب بكم ، الرجاء اختيار المسمى الأنسب لكم"
                                                delegate:self
                                       cancelButtonTitle:@"تخطي"
                                       otherButtonTitles:@"مواطن",@"مقيم",@"زائر", nil];
        
        [alrtCategory show];
    }
    [self setDefaultforLanguageIsAR:appDelegate.isAR];
}

- (IBAction)btnENClicked:(id)sender {
    /*appDelegate.isAR = NO;
    [self setDefaultforLanguageIsAR:appDelegate.isAR];*/
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Under Construction!"
                                                   message:@"We apologize that the english feature is not available on this version, hopefully it will be added on the next update"
                                                  delegate:nil
                                         cancelButtonTitle:@"Back"
                                         otherButtonTitles:nil];
    [alert show];    
}

-(void)setDefaultforLanguageIsAR:(bool)language{
    
    //emptyView.hidden = NO;
    
    [appDelegate.defaults setBool:language forKey:@"isAR"];
    [appDelegate.defaults synchronize];
    
    btnAR.hidden = YES;
    btnEN.hidden = YES;
    logoImgView.hidden = YES;
}

#pragma mark -
#pragma mark UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex buttonIndex: %i",buttonIndex);
    NSString *tempSegue;
    if (alertView == alrtCategory) {
        switch (buttonIndex) {
            case 0:
                
                appDelegate.userCategory = @"tourist";
                tempSegue = @"الصفحة الرئيسية";
                break;
            case 1:
                //appDelegate.userCategory = @"resident";
                tempSegue = @"ControlPanel";
                break;
            case 2:
                //appDelegate.userCategory = @"tourist";
                tempSegue = @"ControlPanel";
                break;
            case 3:
                //appDelegate.userCategory = @"local";
                tempSegue = @"ControlPanel";
                break;
            default:
                break;
        }
        [appDelegate.defaults setObject:appDelegate.userCategory forKey:@"userCategory"];
        [appDelegate.defaults synchronize];
        topEmptyView.hidden = YES;
        bottomEmptyView.hidden = YES;
        emptyView.hidden = YES;
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:tempSegue];
    }
}

@end