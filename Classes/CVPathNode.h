//
//  CVPathNode.h
//  
//
//  Created by Kerem Karatal on 1/27/14.
//
//

#import <Foundation/Foundation.h>
#import "CVResponse.h"

@interface CVPathNode : NSObject
@property(nonatomic, readonly) NSDictionary *subNodes;
@property(nonatomic, strong) CVPathNode *paramNode;
@property(nonatomic, strong) CVResponse *response;

- (void) addNode:(CVPathNode *) node;
- (void) removeNode:(CVPathNode *) node;
@end
