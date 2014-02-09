//
//  TrafficListViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/25/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "TrafficListViewController.h"
#import "AFNetworking.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface TrafficListViewController ()
{
    NSMutableArray *cityList;
    NSMutableArray *streetList;
    IBOutlet UIPickerView *cityPicker;
    IBOutlet UIPickerView *StreetPicker;
    IBOutlet UITableView *tblView;
}
@property (strong, nonatomic) IBOutlet UITableView *tblTrafficFeed;
@end

@implementation TrafficListViewController

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
    defaults = [NSUserDefaults standardUserDefaults];
    feedList = [[NSMutableArray alloc]init];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    tblView.backgroundColor = [UIColor clearColor];
    
    cityList = [self getCityList];
    streetList = [self getStreetListforCity:[cityPicker selectedRowInComponent:0]];
    [cityPicker reloadAllComponents];
    [StreetPicker reloadAllComponents];
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(NSMutableArray*)getCityList
{
    NSMutableArray *tCityList = [[NSMutableArray alloc]initWithObjects:@"أبوظبي",@"الشارقة", nil];
    
    return tCityList;
}

-(NSMutableArray*)getStreetListforCity:(int)cityID
{
    NSMutableArray *tStreetList;
    if (cityID==0) {
        tStreetList = [[NSMutableArray alloc]initWithObjects:@"الكل",@"شارع السلام",@"شارع القرم", nil];
    }else if (cityID == 1)
    {
        tStreetList = [[NSMutableArray alloc]initWithObjects:@"الكل",@"شارع محمد بن زايد",@"شارع الإمارات", nil];
    }
    return tStreetList;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getTrafficFeedList];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خدمة تحديثات مرورية"
                                                   message:@"تحرص خدمة تحديثات مرورية على تنويه المستخدم بحالة الطريق"
                                                  delegate:nil
                                         cancelButtonTitle:@"حسناً"
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Service Methods

-(void)getTrafficFeedList
{
    [feedList removeAllObjects];
    NSLog(@"City ID:%i",[cityPicker selectedRowInComponent:0] + 1);
    NSLog(@"Street ID:%i",[StreetPicker selectedRowInComponent:0]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    @try {
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<GetTrafficFeed xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<city>%i</city>",[cityPicker selectedRowInComponent:0] + 1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<street>%i</street>",[StreetPicker selectedRowInComponent:0]]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</GetTrafficFeed>"]];
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
        [request addValue:@"http://tempuri.org/GetTrafficFeed" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            NSLog(@"response: %@",response);
            userParser = XMLParser;
            userParser.delegate = self;
            [userParser parse];
            
            [_tblTrafficFeed reloadData];
            
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
        NSLog(@"getTrafficFeedList: Caught \nname%@: - \nreason:%@", [exception name], [exception reason]);
    }
}

#pragma mark -
#pragma mark XML Delegate Methods

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
	 attributes:(NSDictionary *)attributeDict
{
	@try {
        if ([elementName isEqualToString:@"FeedList"])
        {
            aFeed = [[TrafficFeed alloc]init];
        }
        myCurrentElement = [NSMutableString stringWithString:elementName];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.description);
    }
    @finally {
        
    }
}

- (void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
	@try {
        if (!currentElementValue)
        {
            currentElementValue = [[NSMutableString alloc]initWithString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
        else
        {
            [currentElementValue appendString:string];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.description);
    }
    @finally {
        
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	@try {
        if ([elementName isEqualToString:@"FeedList"]) {
            [feedList addObject:aFeed];
            aFeed = nil;
        }else{
            [aFeed setValue:currentElementValue forKey:elementName];
        }
        currentElementValue = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.description);
    }
    @finally {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"WorkersCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    TrafficFeed *tempFeed = [feedList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",tempFeed.feedDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tempFeed.description];
    cell.detailTextLabel.numberOfLines=0;
    
    NSString *imageName = [NSString stringWithFormat:@"status%i.png",tempFeed.feedType];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.imageView.frame = CGRectMake(0,0,32,32);
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSString *workerFeed = [workersList objectAtIndex:indexPath.row];
}

#pragma mark - Picker View Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView == cityPicker) {
        return cityList.count;
    }
    if (pickerView == StreetPicker) {
        return streetList.count;
    }
    return 0;
}

#pragma mark - Picker View Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == cityPicker) {
        return [cityList objectAtIndex:row];
    }
    if (pickerView == StreetPicker) {
        return [streetList objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    NSLog(@"selected Row: %i",row);
    if (pickerView == cityPicker) {
        streetList = [self getStreetListforCity:[cityPicker selectedRowInComponent:0]];
        [StreetPicker reloadAllComponents];
    }
    [self getTrafficFeedList];
}

@end
