//
//  CVPathNode.m
//  
//
//  Created by Kerem Karatal on 1/27/14.
//
//

#import "CVPathNode.h"


@interface CVPathNode() {
  NSMutableDictionary *_subNodes;
  NSMutableDictionary *_responses;
}

@end

@implementation CVPathNode

- (id)init
{
  self = [super init];
  if (self) {
    _paramNode = nil;
    _subNodes = [NSMutableDictionary dictionary];
    _responses = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void) addNode:(CVPathNode *) node forPath:(NSString *) pathString{
  [_subNodes setObject:node forKey:pathString];
}

- (void) removeNode:(CVPathNode *) node {
  
}

- (void) addResponse:(CVResponse *) response forRequest:(CVRequest *) request {

  [_responses setObject:response forKey:request];
}

- (CVResponse *) responseFromParamsAndHeadersForRequest:(NSURLRequest *) request {
  CVRequest *cvRequest = [[CVRequest alloc] initWithURLRequest:request useParamsValues:NO];
  CVResponse *response = [_responses objectForKey:cvRequest];
  
  return response;
}

- (NSDictionary *) allResponses {
  return _responses;
}

@end
