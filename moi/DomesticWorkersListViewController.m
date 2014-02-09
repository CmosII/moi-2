//
//  DomesticWorkersListViewController.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/24/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "DomesticWorkersListViewController.h"
#import "AFNetworking.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface DomesticWorkersListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tblWorkersList;

@end

@implementation DomesticWorkersListViewController

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
    workersList = [[NSMutableArray alloc]init];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.75f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    _tblWorkersList.backgroundColor = [UIColor clearColor];
    
    [self getDomesticWorkersList:appDelegate.userName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Service Methods

-(void)getDomesticWorkersList:(NSString*)userName
{
    un = userName;
    @try {
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<GetWorkersFeed xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<email>%@</email>",userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</GetWorkersFeed>"]];
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
        [request addValue:@"http://tempuri.org/GetWorkersFeed" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            NSLog(@"response: %@",response);
            userParser = XMLParser;
            userParser.delegate = self;
            [userParser parse];
            
            [_tblWorkersList reloadData];
            
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
        NSLog(@"getDomesticWorkersList: Caught \nname%@: - \nreason:%@", [exception name], [exception reason]);
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
            aFeed = [[Worker alloc]init];
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
            [workersList addObject:aFeed];
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
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [workersList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"WorkersCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Worker *tempFeed = [workersList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",tempFeed.name];
    //cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tempFeed.feedDetails];
    //cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.numberOfLines=0;
    cell.backgroundColor = [UIColor clearColor];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://htss.somee.com/domestics_personal_photo/%@.jpg",tempFeed.workerID]] placeholderImage:[UIImage imageNamed:@"maid_icon.png"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSString *workerFeed = [workersList objectAtIndex:indexPath.row];
}

@end
