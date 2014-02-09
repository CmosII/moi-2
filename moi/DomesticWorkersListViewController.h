//
//  DomesticWorkersListViewController.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/24/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "htssAppDelegate.h"
#import "Worker.h"

@interface DomesticWorkersListViewController : UIViewController <NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    NSXMLParser *logParser;
    NSString *wsResponse;
    NSString *un;
    
    Worker *aFeed;
    NSMutableArray *workersList;
    NSXMLParser *userParser;
    NSMutableString *currentElementValue;
	NSMutableString *myCurrentElement;
}
@end
