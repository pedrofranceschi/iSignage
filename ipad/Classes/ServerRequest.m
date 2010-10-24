//
//  ServerRequest.m
//  ProjectOrfeuiPhone
//
//  Created by iMac on 14/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

#define SERVER_URL @"http://isignage.heroku.com"

@implementation ServerRequest

- (NSString *)postRequestWithMethod:(NSString *)_method andParams:(NSString *)_params
{
 	NSData *postData = [_params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
  	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, _method]]];
    NSLog(@"%s url: %@", _cmd, [NSString stringWithFormat:@"%@%@", SERVER_URL, _method]);
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	NSError *error;
	NSURLResponse *responser;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&responser error:&error];
	NSString *results = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    return results;
}

@end