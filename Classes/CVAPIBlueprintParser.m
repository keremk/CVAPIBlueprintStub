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

@end

@implementation CVAPIBlueprintParser

- (id)initWithAST:(NSDictionary *)blueprintAST
{
  self = [super init];
  if (self) {
    _blueprintAST = blueprintAST;
  }
  return self;
}

static NSString * const kResourceGroups = @"resourceGroups";
static NSString * const kResources = @"resources";
static NSString * const kUriTemplate = @"uriTemplate";
static NSString * const kParameters = @"parameters";
static NSString * const kHeaders = @"headers";
static NSString * const kExamples = @"examples";
static NSString * const kRequests = @"requests";
static NSString * const kResponses = @"responses";

- (CVPathNode *) parse {
  CVPathNode *rootNode = [[CVPathNode alloc] init];

  return rootNode;
}

- (void) processAST:(NSDictionary *) blueprintAST {
  NSArray *resourceGroups = [blueprintAST objectForKey:kResourceGroups];
  
  [resourceGroups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
  }];
}

- (CVRequest *) createRequestFromURLRequest:(NSURLRequest *) urlRequest {
  CVRequest *cvRequest = [[CVRequest alloc] init];
  
  cvRequest.urlTemplate = [self urlTemplateFromURL:urlRequest.URL];
  cvRequest.method = [urlRequest HTTPMethod];
  cvRequest.params = [self paramsFromURL:urlRequest.URL];
  cvRequest.headers = [urlRequest allHTTPHeaderFields];
  return cvRequest;
}

- (NSString *)urlTemplateFromURL:(NSURL *)url {
  NSString *urlTemplate = nil;
  
  
  return urlTemplate;
}

- (NSDictionary *) paramsFromURL:(NSURL *) url {
  NSMutableDictionary *params = nil;
  
  return params;
}
@end
