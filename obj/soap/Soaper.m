//
//  WebserviceConnector.m
//  HelloThread
//
//  Created by 720QSJ on 15/1/21.
//  Copyright (c) 2015年 Master. All rights reserved.
//

#import "Soaper.h"
#import <UIKit/UIKit.h>

static NSString* _domain = @"http://tempuri.org/";


@implementation Soaper
{
    GDataXMLDocument* soapDom;
    
    double time;
    NSString* url;
    NSString* method;
}


+ (void) setup:(NSString *)domain
{
    _domain = domain;
}

+ (void) connectUrl:(NSString *)url Method:(NSString *)method Param:(NSDictionary *)param Success:(void (^)(NSDictionary *, NSString *))success Error:(void (^)(NSString *, NSString *))error
{
    [Soaper connectTimeout:30 Url:url Method:method Param:param Success:success Error:error];
}

+ (void) connectTimeout:(int)timeout Url:(NSString *)url Method:(NSString *)method Param:(NSDictionary *)param Success:(void (^)(NSDictionary *, NSString *))success Error:(void (^)(NSString *, NSString *))error
{
    Soaper* conn = [[Soaper alloc] initWithTimeinterval:timeout Url:url Method:method];
    if(param){
        for(NSString* key in param){
            //NSLog(@"%@-%@", key, param[key]);
            [conn addParam:key value:param[key]];
        }
    }
    [conn connect:success error:error];
}




- (id) initWithTimeinterval:(double)TIMEOUT Url:(NSString *)URL Method:(NSString *)METHOD
{
    time = TIMEOUT;
    url = URL;
    method = METHOD;
    
    NSString* soapMsg =   @"<soap12:Envelope "
                            "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                            "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                            "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                                "<soap12:Body>"
                                    "<%@ xmlns=\"%@\">"
                                        "<call>"
                                        "</call>"
                                    "</%@>"
                                "</soap12:Body>"
                            "</soap12:Envelope>";
    
    soapMsg = [NSString stringWithFormat:soapMsg, method, _domain, method];
    soapDom = [[GDataXMLDocument alloc] initWithXMLString:soapMsg options:0 error:nil];

    return self;
}

- (void) addParam:(NSString*)key value:(NSString*)value
{
    NSString* param = [NSString stringWithFormat:@"<%@>%@</%@>", key, value, key];
    //GDataXMLElement* methodTag = [[soapDom.rootElement nodesForXPath:[NSString stringWithFormat:@"//*[name()='%@']",method] error:nil] objectAtIndex:0];
    GDataXMLElement* methodTag = [[soapDom.rootElement nodesForXPath:[NSString stringWithFormat:@"//*[name()='%@']",@"call"] error:nil] objectAtIndex:0];
    [methodTag addChild:[[GDataXMLElement alloc] initWithXMLString:param error:nil]];
}


- (void) connect:(void (^)(NSDictionary *rawDic, NSString *rawStr))success error:(void (^)(NSString *errorMsg, NSString *rawStr))error
{
    NSMutableURLRequest *req = [NSMutableURLRequest new];
    [req setHTTPMethod:@"POST"];
    [req setTimeoutInterval:time];
    [req setHTTPBody:[soapDom.rootElement.XMLString dataUsingEncoding:NSUTF8StringEncoding]];
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[NSString stringWithFormat:@"%ld", (long)[soapDom.rootElement.XMLString length]] forHTTPHeaderField:@"Content-Length"];
    [req setURL:[NSURL URLWithString:url]];
    
    //DebugLog(@"%@", soapDom.rootElement.XMLString);
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue]
                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                       NSString* rawStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                       if(connectionError){
                           error(connectionError.localizedDescription, rawStr);
                       }else{
                           NSError* parseErr;
                           NSDictionary* dic ;
                           @try {
                               GDataXMLDocument* dom = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                               GDataXMLElement* resultTag = [[dom.rootElement nodesForXPath:[NSString stringWithFormat:@"//*[name()='%@']",[NSString stringWithFormat:@"%@Result", method]] error:nil] objectAtIndex:0];
                               dic = [NSJSONSerialization JSONObjectWithData:[resultTag.stringValue dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&parseErr];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   success(dic, rawStr);
                               });
                           }@catch (NSException *exception) {
                               error(@"Domain-URL-Method配置不正确" ,rawStr);
                           }
                       }
                   }];
}
@end
