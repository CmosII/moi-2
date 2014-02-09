//
//  SosWS.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 12/1/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "htssAppDelegate.h"

@interface SosWS : NSObject <NSXMLParserDelegate,UIAlertViewDelegate>
{
    htssAppDelegate *appDelegate;
    NSXMLParser *logParser;
    NSUserDefaults *defaults;
    NSString *wsResponse;
}
-(void)requestSoSCategory:(int)categoryID
            ApplicationID:(int)appID
                ServiceID:(int)serviceID;
@end
