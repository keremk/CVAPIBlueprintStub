//
//  CVPathNode.h
//  
//
//  Created by Kerem Karatal on 1/27/14.
//
//

#import <Foundation/Foundation.h>
#import "CVResponse.h"
#import "CVRequest.h"

@interface CVPathNode : NSObject
@property(nonatomic, readonly) NSDictionary *subNodes;
@property(nonatomic, strong) CVPathNode *paramNode;
@property(nonatomic, strong) NSString *pathString;

- (void) addNode:(CVPathNode *) node forPath:(NSString *) pathString;
- (void) removeNode:(CVPathNode *) node;
- (CVResponse *) responseFromParamsAndHeadersForRequest:(NSURLRequest *) request;
- (void) addResponse:(CVResponse *)response forRequest:(CVRequest *) request;
- (NSDictionary *) allResponses;

@end
