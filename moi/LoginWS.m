//
//  LoginWS.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/17/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "LoginWS.h"
#import "AFNetworking.h"

@implementation LoginWS

-(void)getInformationUserName:(NSString*)userName
{
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    un = userName;
    NSLog(@"LoginWS Class!!!!!!");
    NSLog(@"sent userName: %@",userName);
    NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
    @try {
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<GetUserInfo xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<email>%@</email>",userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</GetUserInfo>"]];
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
        [request addValue:@"http://tempuri.org/GetUserInfo" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            NSLog(@"response: %@",response);
            userParser = XMLParser;
            userParser.delegate = self;
            [userParser parse];
            NSLog(@"Before saving user information");
            NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
            [self saveUserInformation];
            NSLog(@"After saving user information");
            NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
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
        NSLog(@"getInformationUserName: Caught %@: %@", [exception name], [exception reason]);
    }
    
    
    NSLog(@"On the end of getInformationUserName function! ??");
    NSLog(@"defaults for key 'userName': %@",[appDelegate.defaults stringForKey:@"userName"]);
}

-(void)saveUserInformation
{
    NSLog(@"saveUserInformation -----aUser Object------");
    NSLog(@"aUser.email: %@",aUser.email);
    NSLog(@"IDNumber: %@",aUser.IDNumber);
    NSLog(@"name: %@",aUser.name);
    NSLog(@"nationality: %@",aUser.nationality);
    NSLog(@"dob: %@",aUser.dob);
    NSLog(@"sex: %@",aUser.sex);
    
    appDelegate.aUser.email = aUser.email;
    appDelegate.aUser.IDNumber = aUser.IDNumber;
    appDelegate.aUser.name = aUser.name;
    appDelegate.aUser.nationality = aUser.nationality;
    appDelegate.aUser.dob = aUser.dob;
    appDelegate.aUser.sex = aUser.sex;
    NSLog(@"==================");
    NSLog(@"aUser.userCategory: %@",aUser.userCategory);
    appDelegate.aUser.userCategory = aUser.userCategory;
    NSLog(@"appDelegate.aUser.userCategory: %@",aUser.userCategory);
    appDelegate.userCategory = aUser.userCategory;
    NSLog(@"==================");
    
    NSLog(@"saveUserInformation -----aUser appDelegate------");
    NSLog(@"aUser.email: %@",appDelegate.aUser.email);
    NSLog(@"IDNumber: %@",appDelegate.aUser.IDNumber);
    NSLog(@"name: %@",appDelegate.aUser.name);
    NSLog(@"nationality: %@",appDelegate.aUser.nationality);
    NSLog(@"dob: %@",appDelegate.aUser.dob);
    NSLog(@"sex: %@",appDelegate.aUser.sex);
    
    [appDelegate.defaults setObject:aUser.email forKey:@"Email"];
    [appDelegate.defaults setObject:aUser.IDNumber forKey:@"IDNumber"];
    [appDelegate.defaults setObject:aUser.name forKey:@"name"];
    [appDelegate.defaults setObject:aUser.nationality forKey:@"nationality"];
    [appDelegate.defaults setObject:aUser.dob forKey:@"dob"];
    [appDelegate.defaults setObject:aUser.sex forKey:@"sex"];
    [appDelegate.defaults setObject:aUser.userCategory forKey:@"userCategory"];
    [appDelegate.defaults synchronize];
}

#pragma mark -
#pragma mark XML Delegate Methods

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
	 attributes:(NSDictionary *)attributeDict
{
	@try {
        if ([elementName isEqualToString:@"User"])
        {
            aUser = [[User alloc]init];
        }
        myCurrentElement = [NSMutableString stringWithString:elementName];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.description);
    }
    @finally {
        
    }
}

- (void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
	@try {
        if (!currentElementValue)
        {
            currentElementValue = [[NSMutableString alloc]initWithString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
        else
        {
            [currentElementValue appendString:string];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.description);
    }
    @finally {
        
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	@try {
        [aUser setValue:currentElementValue forKey:elementName];
        currentElementValue = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception.description);
    }
    @finally {
        
    }
}

@end
