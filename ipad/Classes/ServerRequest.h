//
//  ServerRequest.h
//  ProjectOrfeuiPhone
//
//  Created by iMac on 14/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerRequest : NSObject {

}

- (NSString *)postRequestWithMethod:(NSString *)aMethod andParams:(NSString *)aParams;

@end
