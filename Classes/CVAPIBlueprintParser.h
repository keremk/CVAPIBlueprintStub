//
//  CVAPIBlueprintParser.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>
#import "CVRequest.h"

@interface CVAPIBlueprintParser : NSObject

- (id) initWithAST:(NSDictionary *) blueprintAST;
- (CVRequest *) createRequestFromURLRequest:(NSURLRequest *) request;
- (NSDictionary *) parse;

@end
