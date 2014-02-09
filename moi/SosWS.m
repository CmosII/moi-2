//
//  SosWS.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 12/1/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "SosWS.h"
#import "AFNetworking.h"

@implementation SosWS

-(void)requestSoSCategory:(int)categoryID
            ApplicationID:(int)appID
                ServiceID:(int)serviceID
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
        
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<insertSOSRequest xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%f</Longitude>",appDelegate.locationManager.location.coordinate.latitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%f</Latitude>",appDelegate.locationManager.location.coordinate.longitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<UserName>%@</UserName>",appDelegate.userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<sos_category>%i</sos_category>",categoryID]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<app_id>%i</app_id>",appID]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<service_id>%i</service_id>",serviceID]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</insertSOSRequest>"]];
        //======================end=parameters======================
        soapBody = [soapBody stringByAppendingString:
                    @"</soap:Body>"
                    "</soap:Envelope>"];
        
        NSString *baseURL = @"http://www.htss.somee.com/beladiws.asmx";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"www.htss.somee.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"http://tempuri.org/insertSOSRequest" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            int tResponse = [wsResponse intValue];
            UIAlertView *alert;
            if (tResponse > 1) {
                 alert = [[UIAlertView alloc]initWithTitle:@"أغثني 999"
                                                               message:[NSString stringWithFormat:@"سيتم الاتصال بخدمة أغثني ، رقم البلاغ %i",tResponse]
                                                              delegate:nil
                                                     cancelButtonTitle:@"الاتصال"
                                                     otherButtonTitles:@"العودة",nil];
                [alert setDelegate:self];
            }else{
                alert = [[UIAlertView alloc]initWithTitle:@"أغثني 999"
                                                               message:[NSString stringWithFormat:@"سيتم الاتصال بخدمة أغثني"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"الاتصال"
                                                     otherButtonTitles:@"العودة",nil];
                [alert setDelegate:self];
            }
            alert.delegate = self;
            [alert show];
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
    }else{
        NSLog(@"parsing something else\nfoundCharacters: %@",string);
    }
}

#pragma mark -
#pragma mark Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex: %i",buttonIndex);
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021234567"]];
    }
}

@end
