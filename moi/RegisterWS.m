//
//  RegisterWS.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/26/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "RegisterWS.h"
#import "AFNetworking.h"

@implementation RegisterWS

-(void)RegisterUserName:(NSString*)userName
               Password:(NSString*)password
       VerificationCode:(NSString*)vc
            PhoneNumber:(NSString*)phoneNumber
{
    NSLog(@"inside RegisterUserName");
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<RegisterUserProfile xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<userName>%@</userName>",userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<password>%@</password>",password]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<phone>%@</phone>",phoneNumber]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<verificationCode>%@</verificationCode>",vc]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</RegisterUserProfile>"]];
        //======================end=parameters======================
        soapBody = [soapBody stringByAppendingString:
                    @"</soap:Body>"
                    "</soap:Envelope>"];
        NSLog(@"soapBody: %@",soapBody);
        NSString *baseURL = @"http://www.htss.somee.com/beladiws.asmx";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"www.htss.somee.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"http://tempuri.org/RegisterUserProfile" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            NSLog(@"request success");
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            int tResponse = [wsResponse intValue];
            if (tResponse == 1) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة التسجيل"
                                                               message:[NSString stringWithFormat:@"عطل في الخادم ، الرجاء المحاولة في وقت آخر"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"العودة"
                                                     otherButtonTitles:nil];
                [alert show];
            }else if (tResponse == 2) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة التسجيل"
                                                               message:[NSString stringWithFormat:@"تم تسجيل المستخدم بنجاح"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"العودة"
                                                     otherButtonTitles:nil];
                [alert show];
            }else if (tResponse == 3){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة التسجيل"
                                                               message:[NSString stringWithFormat:@"الرجاء التأكد من رمز التعريف"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"العودة"
                                                     otherButtonTitles:nil];
                [alert show];
            }
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
        NSLog(@"LogClassName: Caught %@: %@", [exception name], [exception reason]);
    }
}

#pragma mark -
#pragma mark XML Parser

- (void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
    if (parser == logParser) {
        wsResponse = string;
        NSLog(@"wsResponse: %@",wsResponse);
    }else{
        NSLog(@"parsing something else\nfoundCharacters: %@",string);
    }
}

@end
