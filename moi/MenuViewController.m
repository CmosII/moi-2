//
//  MenuViewController.m
//  moi
//
//  Created by shjmun Mac on 11/11/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "UIImageView+AFNetworking.h"
#import "htssAppDelegate.h"

@interface MenuViewController ()
{
    NSArray *sosMenu,*menu,*menu2,*menu3,*Section,*sectionNames;
    htssAppDelegate *appDelegate;
}
@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    self.view.frame = CGRectMake(0, 20, 320, 548);
    self.tableView.backgroundColor = [UIColor colorWithRed:(224/255.0) green:(225/255.0) blue:(226/255.0) alpha:1];
    //self.tableView.frame = CGRectMake(0, 20, 320, 548);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    sosMenu = [[NSArray alloc]initWithObjects:@"أغثني", nil];
    
    if ([appDelegate.userName length] != 0) {
        menu = [[NSArray alloc]initWithObjects:appDelegate.userName, @"لوحة الإعدادات",nil];
    }
    else
    {
        menu = [[NSArray alloc]initWithObjects:@"تسجيل الدخول" ,nil];
    }
    
//    menu2 = [[NSArray alloc]initWithObjects:@"سفاري",@"العين الساهرة" , @"ملفي"
//    ,@"تحديثات مرورية" , @"عين الطريق", @"الصفحة الرئيسية",nil];
//    
    NSLog(@"MenuViewController- View Did Load - appDelegate.aUser.userCategory: %@",appDelegate.aUser.userCategory);
    if ([appDelegate.aUser.userCategory isEqualToString:@"local"]) {
        menu2 = [[NSArray alloc]initWithObjects:@"الصفحة الرئيسية",@"ملفي",@"العين الساهرة",@"سفاري",@"عين الطريق",@"تحديثات مرورية",@"أماكن تهمك",nil];
    }else{
        menu2 = [[NSArray alloc]initWithObjects:@"الصفحة الرئيسية",@"العين الساهرة",@"سفاري",@"عين الطريق",@"تحديثات مرورية",@"أماكن تهمك",nil];
    }
    
    menu3 = [[NSArray alloc]initWithObjects:@"أهلا" , @"تتبعني",nil];
    
    Section = [[NSArray alloc]initWithObjects:sosMenu, menu,menu2,menu3, nil];
    
    sectionNames = [[NSArray alloc]initWithObjects:@"الطوارئ 999", @"معلوماتي",@"حياتي الذكية",@"سياحتي الذكية", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return Section.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [menu count];
    NSArray *thisArray = [Section objectAtIndex:section];
    return thisArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 28.0f;
//    if (section == 0) {
//        height = 20.5f + 44;
//    }else{
//        height = 28.0f;
//    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSArray *thisArray = [Section objectAtIndex:indexPath.section];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[thisArray objectAtIndex:indexPath.row]];
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://htss.somee.com/images/%@.png",appDelegate.userName]] placeholderImage:[UIImage imageNamed:@"user_blank.png"]];
        cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:11];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionNames objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:(224/255.0) green:(225/255.0) blue:(226/255.0) alpha:1];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 28.0f)];
    [headerView setBackgroundColor:[UIColor colorWithRed:(37/255.0) green:(82/255.0) blue:(146/255.0) alpha:1]];
    
    UILabel *lblText;
    lblText = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width-2, 28)];
	lblText.numberOfLines = 2;
	[lblText setBackgroundColor:[UIColor clearColor]];
    lblText.textAlignment = NSTextAlignmentLeft;
	lblText.font = [UIFont systemFontOfSize:15];
	lblText.textColor = [UIColor whiteColor];
    lblText.text = [sectionNames objectAtIndex:section];
	[headerView addSubview:lblText];
    
    return headerView;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSArray *thisArray = [Section objectAtIndex:indexPath.section];
    NSString *identifier = [NSString stringWithFormat:@"%@", [thisArray objectAtIndex:indexPath.row]];
    if (thisArray == sosMenu) {
        [self initiateSoS];
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }else
    if (thisArray == menu) {
        NSLog(@"Identifier is: %@",identifier);
        if ((indexPath.row == 1 && appDelegate.userName.length != 0) || ((indexPath.row == 0 && appDelegate.userName.length == 0))) {
            UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ControlPanel"];
            
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = newTopViewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
        }
    }
    else
    {
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
}

#pragma mark - htss methods

-(void)initiateSoS
{
    if (appDelegate.isSafariOn) {
        NSLog(@"Initiate Safari SoS");
    }else{
        NSLog(@"Initiate Standard SoS");
    }
}

@end
