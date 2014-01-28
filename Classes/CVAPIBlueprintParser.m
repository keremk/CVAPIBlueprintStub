//
//  CVAPIBlueprintParser.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVAPIBlueprintParser.h"

@interface CVAPIBlueprintParser()
@property(nonatomic, strong) NSDictionary *blueprintAST;
@property(nonatomic, strong) CVPathNode *rootNode;

@end

@implementation CVAPIBlueprintParser

- (id)initWithAST:(NSDictionary *)blueprintAST
{
  self = [super init];
  if (self) {
    _blueprintAST = blueprintAST;
    _rootNode = [[CVPathNode alloc] init];
    _rootNode.pathString = @"/";
  }
  return self;
}

static NSString * const kResourceGroups = @"resourceGroups";
static NSString * const kResources = @"resources";
static NSString * const kUriTemplate = @"uriTemplate";
static NSString * const kParameters = @"parameters";
static NSString * const kMethod = @"method";
static NSString * const kHeaders = @"headers";
static NSString * const kExamples = @"examples";
static NSString * const kExample = @"example";
static NSString * const kValue = @"value";
static NSString * const kRequests = @"requests";
static NSString * const kResponses = @"responses";
static NSString * const kActions = @"actions";
static NSString * const kBody = @"body";
static NSString * const kName = @"name";

- (void) processAST {
  NSArray *resourceGroups = [self.blueprintAST objectForKey:kResourceGroups];
  
  [resourceGroups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSDictionary *resourceGroup = (NSDictionary *) obj;
    NSArray *resources = [resourceGroup objectForKey:kResources];
    [resources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      NSDictionary *resource = (NSDictionary *) obj;
      NSString *uriTemplate = [resource objectForKey:kUriTemplate];
      NSArray *pathComponents = [uriTemplate pathComponents];
      
      NSMutableArray *potentialParamsStack = [NSMutableArray array];
      NSMutableArray *potentialHeaderStack = [NSMutableArray array];
      
      [potentialParamsStack addObject:[self extractRelevantValueFromKey:kParameters
                                                        inASTDictionary:resource
                                                             fromRawKey:kExample]];
      [potentialHeaderStack addObject:[self extractRelevantValueFromKey:kHeaders
                                                        inASTDictionary:resource
                                                             fromRawKey:kValue]];
      
      CVPathNode *foundNode = [self findOrCreatePathNodeFromPathComponents:pathComponents];
      
      NSArray *actions = [resource objectForKey:kActions];
      [actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *action = (NSDictionary *) obj;
        NSString *potentialMethod = [action objectForKey:kMethod];

        [potentialParamsStack addObject:[self extractRelevantValueFromKey:kParameters
                                                          inASTDictionary:action
                                                               fromRawKey:kExample]];
        [potentialHeaderStack addObject:[self extractRelevantValueFromKey:kHeaders
                                                          inASTDictionary:action
                                                               fromRawKey:kValue]];

        NSArray *examples = [action objectForKey:kExamples];
        [examples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          NSDictionary *example = (NSDictionary *) obj;
          NSArray *requests = [example objectForKey:kRequests];
          NSArray *responses = [example objectForKey:kResponses];
          [requests enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *request = (NSDictionary *) obj;
            [potentialHeaderStack addObject:[self extractRelevantValueFromKey:kHeaders
                                                              inASTDictionary:request
                                                                   fromRawKey:kValue]];

            CVRequest *cvRequest = [[CVRequest alloc] init];
            cvRequest.method = potentialMethod;
            cvRequest.headers = [self finalValueFromStack:potentialHeaderStack];
            cvRequest.params = [self finalValueFromStack:potentialParamsStack];
            
            NSDictionary *response = [responses objectAtIndex:idx];
            CVResponse *cvResponse = [[CVResponse alloc] init];
            cvResponse.body = [response objectForKey:kBody];
            cvResponse.statusCode = [[response objectForKey:kName] intValue];
            cvResponse.headers = [self extractRelevantValueFromKey:kHeaders inASTDictionary:response fromRawKey:kValue];
            
            [foundNode addResponse:cvResponse forRequest:cvRequest];
          }]; // requests
          [potentialParamsStack removeLastObject];
          [potentialHeaderStack removeLastObject];
        }]; // examples
        [potentialParamsStack removeLastObject];
        [potentialHeaderStack removeLastObject];
      }]; // actions
      [potentialParamsStack removeLastObject];
      [potentialHeaderStack removeLastObject];
    }]; // resources
  }]; // resourceGroups
}

- (NSDictionary *) extractRelevantValueFromKey:(NSString *)sourceKey
                               inASTDictionary:(NSDictionary *) dict
                                    fromRawKey:(NSString *) rawKey {
  NSDictionary *rawData = [dict objectForKey:sourceKey];
  NSMutableDictionary *parsedData = [NSMutableDictionary dictionary];
  [rawData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSString *relevantValue = [(NSDictionary *) obj objectForKey:rawKey];
    [parsedData setObject:relevantValue forKey:key];
  }];
  return parsedData;
}

- (id) finalValueFromStack:(NSMutableArray *) stack {
  NSDictionary *finalValue = [NSDictionary dictionary];
  for(NSDictionary *item in [stack reverseObjectEnumerator]) {
    if ([item count] > 0) {
      finalValue = item;
      break;
    }
  }
  return finalValue;
}

- (CVResponse *) responseForRequest:(NSURLRequest *)request{
  [self ensureParsed];
  NSArray *pathComponents = [request.URL pathComponents];
  CVPathNode *foundNode = [self findPathNodeFromPathComponents:pathComponents];
  
  CVResponse *foundResponse = nil;
  if (nil != foundNode) {
    foundResponse = [foundNode responseFromParamsAndHeadersForRequest:request];
  }
  
  return foundResponse;
}

- (CVPathNode *) findOrCreatePathNodeFromPathComponents:(NSArray *) pathComponents  {
  __block CVPathNode *foundNode = nil;
  __block CVPathNode *startNode = self.rootNode;
  
  [pathComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *pathString = (NSString *) obj;
    CVPathNode *newNode = [startNode.subNodes objectForKey:pathString];
    if (nil == newNode && nil == startNode.paramNode) {
      newNode = [[CVPathNode alloc] init];
      newNode.pathString = pathString;
      if ([self isParamNodeFromPathString:pathString]) {
        startNode.paramNode = newNode;
      } else {
        [startNode addNode:newNode forPath:pathString];
      }
      startNode = newNode;
    } else {
      if (nil == newNode) {
        newNode = startNode.paramNode;
      }
      startNode = newNode;
      foundNode = newNode;
    }
  }];
  return foundNode;
}

- (BOOL) isParamNodeFromPathString:(NSString *) pathString {
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"{"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  NSUInteger numberOfMatches = [regex numberOfMatchesInString:pathString
                                                      options:0
                                                        range:NSMakeRange(0, [pathString length])];
  
  BOOL isParamString = NO;
  if (numberOfMatches > 0) {
    isParamString = YES;
  }
  return isParamString;
}

- (CVPathNode *) findPathNodeFromPathComponents:(NSArray *) pathComponents {
  __block CVPathNode *foundNode = nil;
  __block CVPathNode *startNode = self.rootNode;
  
  [pathComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *nodeName = (NSString *) obj;
    CVPathNode *newNode = [startNode.subNodes objectForKey:nodeName];
    if (nil == newNode && nil == startNode.paramNode) {
      *stop = YES;
    } else {
      if (nil == newNode) {
        newNode = startNode.paramNode;
      }
      startNode = newNode;
      foundNode = newNode;
    }
  }];
  return foundNode;
  
}

- (void) ensureParsed {
  if (nil == self.rootNode) {
    [self processAST];
  }
}

@end
