//
//  TrafficListViewController.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/25/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "htssAppDelegate.h"
#import "TrafficFeed.h"

@interface TrafficListViewController : UIViewController <NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    NSXMLParser *logParser;
    NSString *wsResponse;
    NSString *un;
    
    TrafficFeed *aFeed;
    NSMutableArray *feedList;
    NSXMLParser *userParser;
    NSMutableString *currentElementValue;
	NSMutableString *myCurrentElement;
}

@end
