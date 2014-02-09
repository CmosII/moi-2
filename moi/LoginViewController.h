//
//  LoginViewController.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/17/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "htssAppDelegate.h"

@interface LoginViewController : UIViewController <NSXMLParserDelegate>
{
    htssAppDelegate *appDelegate;
    NSXMLParser *logParser;
    NSString *wsResponse;
    NSString *un;
}
@property(strong,nonatomic)UIButton *btnMenu;

-(void)CheckIfLoginIsSuccessfulUserName:(NSString*)userName
                               Password:(NSString*)password;
@end
