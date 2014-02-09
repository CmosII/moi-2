//
//  RoadEyesWS.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/26/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "RoadEyesWS.h"
#import "AFNetworking.h"

@implementation RoadEyesWS

-(void)SubmitRoadReportLogLongitude:(double)longitude
                          Lattitude:(double)latitude
                         ReportType:(int)rType
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy hh:mm a"];
        NSString *rDate = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
        
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<insertRoadReport xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ReportDate>%@</ReportDate>",rDate]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%f</Longitude>",appDelegate.locationManager.location.coordinate.latitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%f</Latitude>",appDelegate.locationManager.location.coordinate.longitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<UserName>%@</UserName>",appDelegate.userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ReportType>%i</ReportType>",rType]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</insertRoadReport>"]];
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
        [request addValue:@"http://tempuri.org/insertRoadReport" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            int tResponse = [wsResponse intValue];
            if (tResponse > 1) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة التسجيل"
                                                               message:[NSString stringWithFormat:@"تم تسجيل البلاغ %i بنجاح",tResponse]
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
    }else{
        NSLog(@"parsing something else\nfoundCharacters: %@",string);
    }
}

@end
