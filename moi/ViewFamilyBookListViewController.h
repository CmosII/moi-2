//
//  ViewFamilyBookListViewController.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/23/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "htssAppDelegate.h"
#import "FamilyMember.h"

@interface ViewFamilyBookListViewController : UIViewController <NSXMLParserDelegate>
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
    NSXMLParser *logParser;
    NSString *wsResponse;
    NSString *un;
    
    FamilyMember *aMember;
    NSXMLParser *userParser;
    NSMutableString *currentElementValue;
	NSMutableString *myCurrentElement;
}

-(void)getFamilyMembersList:(NSString*)userName;
@end
