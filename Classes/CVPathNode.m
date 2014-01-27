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
}

@end

@implementation CVPathNode

- (id)init
{
  self = [super init];
  if (self) {
    _paramNode = nil;
    _subNodes = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void) addNode:(CVPathNode *) node {
  
}

- (void) removeNode:(CVPathNode *) node {
  
}

@end
