//
//  AinSaheraViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/18/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "AinSaheraViewController.h"
#import "AinSaheraWS.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface AinSaheraViewController ()
{
    IBOutlet UIView *catView;
    IBOutlet UIPickerView *categoryPicker;
    NSMutableArray *categoryList;
}
@property (strong, nonatomic) IBOutlet UIImageView *chosenImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtComment;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnNumber;

@end

@implementation AinSaheraViewController
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
    NSLog(@"userName: %@",appDelegate.userName);
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    _btnNumber.hidden = YES;
    catView.hidden = YES;
    categoryList = [NSMutableArray arrayWithObjects:@"مرصد",@"خدمة أمان",@"الشرطة المجتمعية",@"عائق طريق",@"حيوانات سائبة",@"الإدلاء بمعلومة" ,@"أخرى",nil];
    [categoryPicker reloadAllComponents];
    
    if (appDelegate.userName.length > 0) {
        _txtName.text = appDelegate.aUser.name;
        //_txtPhone.text = appDelegate.aUser.
        
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

#pragma mark - htss methods

- (IBAction)btnPicClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}

- (IBAction)btnCameraCliced:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(IBAction)btnHideKeyboard:(id)sender
{
    [sender resignFirstResponder];
}


- (IBAction)btnTypeClicked:(id)sender {
    catView.hidden = NO;
}

- (IBAction)btnSubmitClicked:(id)sender {
    AinSaheraWS *ws = [[AinSaheraWS alloc]init];

    [ws SubmitIssueContactName:_txtName.text
                 ContactNumber:_txtPhone.text
                         longi:appDelegate.locationManager.location.coordinate.longitude
                           Lat:appDelegate.locationManager.location.coordinate.latitude
                          Desc:_txtComment.text
                   SubmitImage:_chosenImgView.image
                      IssueCat:[categoryPicker selectedRowInComponent:0]];
}

- (IBAction)txtNameDone:(id)sender {
    [sender resignFirstResponder];
}

-(IBAction)txtNumberClicked:(id)sender
{
    //self.view.frame =
    _btnNumber.hidden = NO;
}

- (IBAction)btnNumberClicked:(id)sender {
    [_txtPhone resignFirstResponder];
    _btnNumber.hidden = YES;
}

- (IBAction)btnSelectCategoryClicked:(id)sender {
    catView.hidden = YES;
    _lblCategory.text = [categoryList objectAtIndex:[categoryPicker selectedRowInComponent:0]];
}

#pragma mark - Image Picker Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    _chosenImgView.image = img;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Text View Delegates

- (void)textFieldDidBeginEditing:(UITextView *)textView {
    self.view.frame = CGRectMake(0, -160, 320, 548);
}

-(BOOL)textFieldShouldEndEditing:(UITextView *)textView {
    self.view.frame = CGRectMake(0, 0, 320, 548);
    return YES;
}

#pragma mark - Picker View Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    int r = 0;
    if (pickerView == categoryPicker) {
        r = categoryList.count;
    }
    return r;
}

#pragma mark - Picker View Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == categoryPicker) {
        return [categoryList objectAtIndex:row];
    }
    return @"";
}

@end
