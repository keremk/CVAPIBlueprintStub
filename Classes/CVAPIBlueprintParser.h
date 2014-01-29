//
//  CVAPIBlueprintParser.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>
#import "CVRequest.h"
#import "CVPathNode.h"

@interface CVAPIBlueprintParser : NSObject

@property(nonatomic, strong) CVPathNode *rootNode;

- (id) initWithAST:(NSDictionary *) blueprintAST;
- (CVResponse *) responseForRequest:(NSURLRequest *)request;
- (void) ensureParsed;
- (void) processAST;
@end
