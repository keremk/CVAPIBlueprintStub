//
//  CVResponse.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>

@interface CVResponse : NSObject

- (NSData *) body;
- (NSInteger *) statusCode;
- (NSDictionary *) headers;
@end
