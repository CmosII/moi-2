//
//  SafariWS.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/16/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "htssAppDelegate.h"

@interface SafariWS : NSObject <NSXMLParserDelegate>
{
    htssAppDelegate *appDelegate;
    NSXMLParser *logParser;
    NSUserDefaults *defaults;
    NSString *wsResponse;
}


-(void)SubmitSafariTripLong:(double)longitude
                             Lat:(double)latitude
                            From:(NSDate*)dFrom
                              To:(NSDate*)dTo
                            Desc:(NSString*)Description
                          mNames:(NSArray*)MemberNames
                         mPhones:(NSArray*)MemberPhones
                          cNames:(NSArray*)ContactNames
                         cPhones:(NSArray*)ContactPhones;

-(void)EditSafariTripLong:(double)longitude
                      Lat:(double)latitude
                     From:(NSDate*)dFrom
                       To:(NSDate*)dTo
                     Desc:(NSString*)Description
                   mNames:(NSArray*)MemberNames
                  mPhones:(NSArray*)MemberPhones
                   cNames:(NSArray*)ContactNames
                  cPhones:(NSArray*)ContactPhones;

@end
