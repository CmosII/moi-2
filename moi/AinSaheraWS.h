//
//  AinSaheraWS.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/19/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "htssAppDelegate.h"

@interface AinSaheraWS : NSObject <NSXMLParserDelegate>
{
    htssAppDelegate *appDelegate;
    NSXMLParser *logParser;
    NSUserDefaults *defaults;
    NSString *wsResponse;
}
-(void)SubmitIssueContactName:(NSString*)contactName
                ContactNumber:(NSString*)contactNumber
                        longi:(double)longitude
                          Lat:(double)latitude
                         Desc:(NSString*)Description
                  SubmitImage:(UIImage*)img
                     IssueCat:(int)issueCat;
@end
