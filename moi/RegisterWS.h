//
//  RegisterWS.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/26/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "htssAppDelegate.h"

@interface RegisterWS : NSObject <NSXMLParserDelegate>
{
    htssAppDelegate *appDelegate;
    NSXMLParser *logParser;
    NSUserDefaults *defaults;
    NSString *wsResponse;
}
-(void)RegisterUserName:(NSString*)userName
               Password:(NSString*)password
       VerificationCode:(NSString*)vc
            PhoneNumber:(NSString*)phoneNumber;
@end
