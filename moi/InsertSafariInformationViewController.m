//
//  InsertSafariInformationViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/16/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "InsertSafariInformationViewController.h"
#import "htssAppDelegate.h"
#import "SafariWS.h"

@interface InsertSafariInformationViewController ()
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    
    UIDatePicker *dpFrom,*dpTo;
    UIView *dpView;
    IBOutlet UIButton *btnSubmit;
}

@property (strong, nonatomic) IBOutlet UITextField *txtLong;
@property (strong, nonatomic) IBOutlet UITextField *txtLat;
@property (strong, nonatomic) IBOutlet UILabel *lblFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblTo;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtMember1Name;
@property (strong, nonatomic) IBOutlet UITextField *txtMember1Phone;
@property (strong, nonatomic) IBOutlet UITextField *txtContact1Name;
@property (strong, nonatomic) IBOutlet UITextField *txtContact1Phone;
@property (strong, nonatomic) IBOutlet UIButton *btnNumber;

@end

@implementation InsertSafariInformationViewController

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
    
    [self insertDPView];
    [self insertDpFrom];
    [self insertDpTo];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy hh:mm a"];
    _lblFrom.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    _lblTo.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    _btnNumber.hidden = YES;
    if (appDelegate.isSafariOn) {
        [btnSubmit setTitle:@"تعديل البيانات" forState:UIControlStateNormal];
    }else{
        [btnSubmit setTitle:@"تسجيل الرحلة" forState:UIControlStateNormal];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (appDelegate.selectedSafariCoordLat != 0) {
        _txtLong.text = [NSString stringWithFormat:@"%f",appDelegate.selectedSafariCoordLong];
        _txtLat.text = [NSString stringWithFormat:@"%f",appDelegate.selectedSafariCoordLat];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insertDpFrom
{
    dpFrom = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 332, 320, 216)];
    dpFrom.datePickerMode = UIDatePickerModeDateAndTime;
    dpFrom.hidden = YES;
    dpFrom.date = [NSDate date];
    
    [dpFrom addTarget:self action:@selector(changeFromLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dpFrom];
}

-(void)insertDpTo
{
    dpTo = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 332, 320, 216)];
    dpTo.datePickerMode = UIDatePickerModeDateAndTime;
    dpTo.hidden = YES;
    dpTo.date = [NSDate date];
    
    [dpTo addTarget:self action:@selector(changeToLabel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dpTo];
}

-(void)insertDPView
{
    dpView = [[UIView alloc]initWithFrame:CGRectMake(0, 332, 320, 216)];
    dpView.backgroundColor = [UIColor whiteColor];
    dpView.hidden = YES;
    [self.view addSubview:dpView];
}

#pragma mark - htss methods

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)resignKeyboard:(id)sender
{
}

- (IBAction)txtFieldShouldReturn:(UITextField *)sender {
    [_txtMember1Name resignFirstResponder];
}

- (IBAction)btnSubmitClicked:(id)sender {
    SafariWS *ws = [[SafariWS alloc]init];
    NSArray *memNames = [[NSArray alloc]initWithObjects:_txtMember1Name.text, nil];
    NSArray *memContact = [[NSArray alloc]initWithObjects:_txtMember1Phone.text, nil];
    NSArray *conNames = [[NSArray alloc]initWithObjects:_txtContact1Name.text, nil];
    NSArray *conContacts = [[NSArray alloc]initWithObjects:_txtContact1Phone.text, nil];
    if (appDelegate.isSafariOn) {
        [ws EditSafariTripLong:appDelegate.selectedSafariCoordLong
                           Lat:appDelegate.selectedSafariCoordLat
                          From:dpFrom.date
                            To:dpTo.date
                          Desc:_txtDescription.text
                        mNames:memNames
                       mPhones:memContact
                        cNames:conNames
                       cPhones:conContacts];
    }else{
        [ws SubmitSafariTripLong:appDelegate.selectedSafariCoordLong
                             Lat:appDelegate.selectedSafariCoordLat
                            From:dpFrom.date
                              To:dpTo.date
                            Desc:_txtDescription.text
                          mNames:memNames
                         mPhones:memContact
                          cNames:conNames
                         cPhones:conContacts];
    }
}

- (IBAction)btnSelectLocationClicked:(id)sender {
    [self performSegueWithIdentifier:@"ToSelectSafariLocation" sender:self];
}



- (IBAction)btnFromClicked:(id)sender {
    dpTo.hidden = YES;
    if (dpFrom.hidden) {
        dpFrom.hidden = NO;
        dpView.hidden = NO;
    }else{
        dpFrom.hidden = YES;
        dpView.hidden = YES;
    }
}

- (IBAction)btnToClicked:(id)sender {
    dpFrom.hidden = YES;
    if (dpTo.hidden) {
        dpTo.hidden = NO;
        dpView.hidden = NO;
    }else{
        dpTo.hidden = YES;
        dpView.hidden = YES;
    }
}

-(void)changeToLabel:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy hh:mm a"];
    _lblTo.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dpTo.date]];
}

-(void)changeFromLabel:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy hh:mm a"];
    _lblFrom.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dpFrom.date]];
}

- (IBAction)btnHideKeyboard:(id)sender {
    [_txtDescription resignFirstResponder];
    [_txtMember1Phone resignFirstResponder];
    [_txtContact1Name resignFirstResponder];
    [_txtContact1Phone resignFirstResponder];
    [_txtLat resignFirstResponder];
    [_txtLong resignFirstResponder];
}

- (IBAction)btnNumberClicked:(id)sender {
    [_txtMember1Phone resignFirstResponder];
    [_txtContact1Phone resignFirstResponder];
    _btnNumber.hidden = YES;
}

-(IBAction)txtNumberClicked:(id)sender
{
    //self.view.frame =
    _btnNumber.hidden = NO;
}

#pragma mark - Text View Delegates

- (void)textFieldDidBeginEditing:(UITextView *)textView {
    self.view.frame = CGRectMake(0, -160, 320, 548);
}

-(BOOL)textFieldShouldEndEditing:(UITextView *)textView {
    self.view.frame = CGRectMake(0, 0, 320, 548);
    return YES;
}

@end
