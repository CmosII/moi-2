//
//  LoginViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/17/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "LoginViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "LoginWS.h"
#import "AFNetworking.h"
#import "LogoutViewController.h"

@interface LoginViewController ()
{
    
}
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

#pragma mark - htss methods


- (IBAction)loginClicked:(id)sender {
    [self CheckIfLoginIsSuccessfulUserName:_txtUserName.text Password:_txtPassword.text];
}

-(void)CheckIfLoginIsSuccessfulUserName:(NSString*)userName
                               Password:(NSString*)password
{
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    un = userName;
    @try {
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<LogInFunction xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<userName>%@</userName>",userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<password>%@</password>",password]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</LogInFunction>"]];
        //======================end=parameters======================
        soapBody = [soapBody stringByAppendingString:
                    @"</soap:Body>"
                    "</soap:Envelope>"];
        
        NSString *baseURL = @"http://www.htss.somee.com/beladiws.asmx";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"www.htss.somee.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"http://tempuri.org/LogInFunction" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            UIAlertView *alert;
            if ([wsResponse isEqualToString:@"1"]) {
                [self LoginSucessful];
                alert = [[UIAlertView alloc]initWithTitle:@"تسجيل الدخول"
                                                  message:@"تمت بتجاح"
                                                 delegate:nil
                                        cancelButtonTitle:@"العودة"
                                        otherButtonTitles:nil];
            }else{
                alert = [[UIAlertView alloc]initWithTitle:@"تسجيل الدخول"
                                                  message:@"غير صحيحة"
                                                 delegate:nil
                                        cancelButtonTitle:@"العودة"
                                        otherButtonTitles:nil];
            }
            
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } failure:
                                            ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
                                                
                                                NSLog(@"Operation Failed");
                                                NSLog(@"Reponse.Description: %@",response.description);
                                                NSLog(@"error.description: %@",error.description);
                                            }] ;
        [operation start];
    }
    @catch (NSException *exception) {
        NSLog(@"CheckIfLoginIsSuccessfulUserName: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(void)LoginSucessful
{
    NSLog(@"LoginSucessful - un: %@",un);
    appDelegate.userName = un;
    NSLog(@"LoginSucessful - appDelegate.userName: %@",appDelegate.userName);
    [appDelegate.defaults setObject:un forKey:@"userName"];
    NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
    [appDelegate.defaults synchronize];
    NSLog(@"After Syncing.........");
    NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
    LoginWS *ws = [[LoginWS alloc]init];
    [ws getInformationUserName:un];
    NSLog(@"After 'getInformationUserName'.........");
    NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(DoLongInSegue) userInfo:nil repeats:NO];
    //[self performSelector:@selector(DoLongInSegue) withObject:nil afterDelay:1.0];
}

-(void)DoLongInSegue
{
    [self performSegueWithIdentifier:@"LogIn" sender:self];
}

- (IBAction)btnRegisterClicked:(id)sender {
    [self performSegueWithIdentifier:@"ResgisterUserSegue" sender:self];
}

#pragma mark -
#pragma mark Segue Delegates

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LogIn"]) {
        LogoutViewController *viewController = [segue destinationViewController];
        viewController.isSegueIn = YES;
    }
}

#pragma mark -
#pragma mark XML Parser

- (void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
    if (parser == logParser) {
        wsResponse = string;
    }else{
        NSLog(@"parsing something else\nfoundCharacters: %@",string);
    }
}

@end
