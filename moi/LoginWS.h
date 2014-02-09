//
//  LoginWS.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/17/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "htssAppDelegate.h"
#import "User.h"

@interface LoginWS : NSObject <NSXMLParserDelegate>
{
    htssAppDelegate *appDelegate;
    NSXMLParser *logParser;
    NSString *wsResponse;
    NSString *un;
    
    User *aUser;
    NSXMLParser *userParser;
    NSMutableString *currentElementValue;
	NSMutableString *myCurrentElement;
}
-(void)getInformationUserName:(NSString*)userName;

@end
