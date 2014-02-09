//
//  SocialMediaViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/29/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "SocialMediaViewController.h"
#import "htssAppDelegate.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface SocialMediaViewController ()
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    
    IBOutlet UIWebView *myWebView;
}
@end

@implementation SocialMediaViewController
@synthesize urlString;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[myWebView loadRequest:request];
}

#pragma mark - WebView Delegates

- (IBAction)PreviousPageClicked:(id)sender {
    [myWebView goBack];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)myWebView
{
    [self endLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self endLoading];
}

#pragma - Loading Methods

-(void)startLoading
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)endLoading
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
