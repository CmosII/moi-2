//
//  MainMenuViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/28/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "htssAppDelegate.h"
#import "DelegatorViewController.h"
#import "SocialMediaViewController.h"

@interface MainMenuViewController ()
{
    htssAppDelegate *appDelegate;
    
    IBOutlet UIScrollView *dashScrollView;
    UIButton *btnNews;
    UILabel *lblNews;
    UIButton *btnEServices;
    UILabel *lblEServices;
    UIButton *btnAbout;
    UILabel *lblAbout;
    UIButton *btnDep;
    UILabel *lblDep;
    UIButton *btnContact;
    UILabel *lblContact;
    int ix,lx,blockSize;
    
    UIButton *mBtn;
    IBOutlet UIPageControl *PageController;
}
@end

@implementation MainMenuViewController

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
    
    ix = 120;
    lx = (320/2)-36-14;
    blockSize = ix;
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    dashScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 143, 320, 100)];
    [dashScrollView setBackgroundColor:[UIColor clearColor]];
	[dashScrollView setCanCancelContentTouches:NO];
	//dashScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	dashScrollView.clipsToBounds = YES;
	dashScrollView.scrollEnabled = YES;
    dashScrollView.showsHorizontalScrollIndicator=NO;
	//dashScrollView.pagingEnabled = YES;
    
    
	[dashScrollView setContentSize:CGSizeMake(blockSize*7, 100)];
    dashScrollView.delegate = self;
    [self.view addSubview:dashScrollView];
    
    
    //=====================About====================================
    btnAbout = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnAbout setImage:[UIImage imageNamed:@"moi_logo_transperant(no words).png"] forState:UIControlStateNormal];
	btnAbout.alpha = 0.5;
    btnAbout.frame = CGRectMake(ix + 5, 10, 72, 72);
    [btnAbout addTarget:self action:@selector(btnAboutClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dashScrollView addSubview:btnAbout];
	lblAbout = [[UILabel alloc] initWithFrame:CGRectMake(lx, 70, 100, 30)];
	lblAbout.numberOfLines = 2;
	[lblAbout setBackgroundColor:[UIColor clearColor]];
    lblAbout.textAlignment = NSTextAlignmentCenter;
	lblAbout.font = [UIFont systemFontOfSize:15];
	lblAbout.textColor = [UIColor blueColor];
    lblAbout.text = @"نبذة عن الوزارة";
	[dashScrollView addSubview:lblAbout];
    
    //=====================Departments====================================
    btnDep = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnDep setImage:[UIImage imageNamed:@"moi_logo_transperant(no words).png"] forState:UIControlStateNormal];
	btnDep.alpha = 0.5;
    btnDep.frame = CGRectMake(ix*2, 10, 72, 72);
    [btnDep addTarget:self action:@selector(btnDepClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dashScrollView addSubview:btnDep];
	lblDep = [[UILabel alloc] initWithFrame:CGRectMake(lx*2 + 5, 70, 100, 30)];
	lblDep.numberOfLines = 2;
	[lblDep setBackgroundColor:[UIColor clearColor]];
    lblDep.textAlignment = NSTextAlignmentCenter;
	lblDep.font = [UIFont systemFontOfSize:15];
	lblDep.textColor = [UIColor blueColor];
    lblDep.text = @"إدارات الوزارة";
	[dashScrollView addSubview:lblDep];
    
    //=====================News====================================
    btnNews = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnNews setImage:[UIImage imageNamed:@"moi_logo_transperant(no words).png"] forState:UIControlStateNormal];
	btnNews.alpha = 0.5;
    btnNews.frame = CGRectMake(ix*3, 10, 72, 72);
    [btnNews addTarget:self action:@selector(btnNewsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dashScrollView addSubview:btnNews];
	lblNews = [[UILabel alloc] initWithFrame:CGRectMake(lx*3 + 15, 70, 100, 30)];
	lblNews.numberOfLines = 2;
	[lblNews setBackgroundColor:[UIColor clearColor]];
    lblNews.textAlignment = NSTextAlignmentCenter;
	lblNews.font = [UIFont systemFontOfSize:15];
	lblNews.textColor = [UIColor blueColor];
    lblNews.text = @"الأخبار";
	[dashScrollView addSubview:lblNews];
    
    //=====================EServices====================================
    btnEServices = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnEServices setImage:[UIImage imageNamed:@"moi_logo_transperant(no words).png"] forState:UIControlStateNormal];
	btnEServices.alpha = 0.5;
    btnEServices.frame = CGRectMake(ix*4, 10, 72, 72);
    [btnEServices addTarget:self action:@selector(btnEServiceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dashScrollView addSubview:btnEServices];
	lblEServices = [[UILabel alloc] initWithFrame:CGRectMake(lx*4 + 25, 70, 100, 30)];
	lblEServices.numberOfLines = 2;
	[lblEServices setBackgroundColor:[UIColor clearColor]];
    lblEServices.textAlignment = NSTextAlignmentCenter;
	lblEServices.font = [UIFont systemFontOfSize:15];
	lblEServices.textColor = [UIColor blueColor];
    lblEServices.text = @"خدمات للجمهور";
	[dashScrollView addSubview:lblEServices];
    
    //=====================Contact Us====================================
    btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnContact setImage:[UIImage imageNamed:@"moi_logo_transperant(no words).png"] forState:UIControlStateNormal];
	btnContact.alpha = 0.5;
    btnContact.frame = CGRectMake(ix*5, 10, 72, 72);
    [btnContact addTarget:self action:@selector(btnContactClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dashScrollView addSubview:btnContact];
	lblContact = [[UILabel alloc] initWithFrame:CGRectMake(lx*5 + 35, 70, 100, 30)];
	lblContact.numberOfLines = 2;
	[lblContact setBackgroundColor:[UIColor clearColor]];
    lblContact.textAlignment = NSTextAlignmentCenter;
	lblContact.font = [UIFont systemFontOfSize:15];
	lblContact.textColor = [UIColor blueColor];
    lblContact.text = @"اتصل بنا";
	[dashScrollView addSubview:lblContact];
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
#pragma mark Scroll View Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat pageWidth = blockSize;//scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+2;
	PageController.currentPage = page - 1;
    switch (page) {
        case 1:
            [self buttonInMiddle:btnAbout];
            break;
        case 2:
            [self buttonInMiddle:btnDep];
            break;
        case 3:
            [self buttonInMiddle:btnNews];
            break;
        case 4:
            [self buttonInMiddle:btnEServices];
            break;
        case 5:
            [self buttonInMiddle:btnContact];
            break;
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    CGPoint point = CGPointMake(mBtn.frame.origin.x - blockSize - 5, 0);
    CGRect frame = CGRectMake(point.x, point.y, dashScrollView.frame.size.width, dashScrollView.frame.size.height);
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{ [dashScrollView scrollRectToVisible:frame animated:NO]; }
                     completion:NULL];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = CGPointMake(mBtn.frame.origin.x - blockSize - 5, 0);
    CGRect frame = CGRectMake(point.x, point.y, dashScrollView.frame.size.width, dashScrollView.frame.size.height);
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{ [dashScrollView scrollRectToVisible:frame animated:NO]; }
                     completion:NULL];
}

-(void)buttonInMiddle:(UIButton*)middleButton
{
    btnNews.alpha = 0.5;
    btnEServices.alpha = 0.5;
    btnAbout.alpha = 0.5;
    btnDep.alpha = 0.5;
    btnContact.alpha = 0.5;
    btnNews.enabled = NO;
    btnEServices.enabled = NO;
    btnAbout.enabled = NO;
    btnDep.enabled = NO;
    btnContact.enabled = NO;
    middleButton.alpha = 1;
    middleButton.enabled = YES;
    mBtn = nil;
    mBtn = middleButton;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self buttonInMiddle:btnAbout];
}

#pragma mark - htss methods

-(IBAction)btnEServiceClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MeService" sender:self];
}

-(IBAction)btnAboutClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MAbout" sender:self];
}

-(IBAction)btnDepClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MDep" sender:self];
}

- (IBAction)btnSoSClicked:(id)sender {
    [self performSegueWithIdentifier:@"MSoS" sender:self];
}

-(IBAction)btnNewsClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MNews" sender:self];
}

-(IBAction)btnContactClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MContact" sender:self];
}

- (IBAction)btnFBClicked:(id)sender {
    [self performSegueWithIdentifier:@"FBSegue" sender:self];
}

- (IBAction)btnTwitterClicked:(id)sender {
    [self performSegueWithIdentifier:@"TwitterSegue" sender:self];
}

- (IBAction)btnYouTubeClicked:(id)sender {
    [self performSegueWithIdentifier:@"YouTubeSegue" sender:self];
}

- (IBAction)btnInstagramClicked:(id)sender {
    [self performSegueWithIdentifier:@"InstagramSegue" sender:self];
}

- (IBAction)btnKeekClicked:(id)sender {
    [self performSegueWithIdentifier:@"KeekSegue" sender:self];
}

#pragma mark -
#pragma mark Segue Delegates

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MeService"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        viewController.sID = @"الخدمات الالكترونية";
    }else if ([[segue identifier] isEqualToString:@"MNews"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        viewController.sID = @"الأخبار";
    }else if ([[segue identifier] isEqualToString:@"MAbout"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        viewController.sID = @"نبذة عن الوزارة";
    }else if ([[segue identifier] isEqualToString:@"MDep"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        viewController.sID = @"الإدارات";
    }else if ([[segue identifier] isEqualToString:@"MContact"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        viewController.sID = @"اتصل بنا";
    }else if ([[segue identifier] isEqualToString:@"MSoS"]) {
        DelegatorViewController *viewController = [segue destinationViewController];
        viewController.sID = @"أغثني";
    }
    //====================================Social Media=======================================
    else if ([[segue identifier] isEqualToString:@"FBSegue"]) {
        SocialMediaViewController *viewController = [segue destinationViewController];
        viewController.urlString = @"https://m.facebook.com/AbuDhabiPolice";
    }else if ([[segue identifier] isEqualToString:@"TwitterSegue"]) {
        SocialMediaViewController *viewController = [segue destinationViewController];
        viewController.urlString = @"https://twitter.com/AbuDhabiPolice";
    }else if ([[segue identifier] isEqualToString:@"YouTubeSegue"]) {
        SocialMediaViewController *viewController = [segue destinationViewController];
        viewController.urlString = @"http://www.youtube.com/user/theabudhabipolice";
    }else if ([[segue identifier] isEqualToString:@"InstagramSegue"]) {
        SocialMediaViewController *viewController = [segue destinationViewController];
        viewController.urlString = @"http://instagram.com/moi_uae";
    }else if ([[segue identifier] isEqualToString:@"KeekSegue"]) {
        SocialMediaViewController *viewController = [segue destinationViewController];
        viewController.urlString = @"https://www.keek.com/MOIUAE";
    }
}

@end
