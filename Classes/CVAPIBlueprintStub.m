//
//  CVAPIBlueprintStub.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVAPIBlueprintStub.h"
#import "CVAPIBlueprintParser.h"
#import "CVPathNode.h"

@interface CVAPIBlueprintStub()
@property(nonatomic, strong) CVAPIBlueprintParser *blueprintParser;
@property(nonatomic, strong) CVPathNode *rootNode;

- (id)initWithParser:(CVAPIBlueprintParser *) blueprintParser;
@end

@implementation CVAPIBlueprintStub

+ (CVAPIBlueprintStub *) stubFromBlueprintAST:(NSString *) blueprintASTFilename {
  NSString *filePath = [[NSBundle bundleForClass: [CVAPIBlueprintStub class]] pathForResource:blueprintASTFilename ofType:@"json"];
  NSError *error;
  NSData *jsonASTData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  NSDictionary *blueprintAST = [NSJSONSerialization JSONObjectWithData:jsonASTData
                                                               options:kNilOptions
                                                                 error:&error];
  
  CVAPIBlueprintParser *parser = [[CVAPIBlueprintParser alloc] initWithAST:blueprintAST];
  CVAPIBlueprintStub *stub = [[CVAPIBlueprintStub alloc] initWithParser:parser];
  return stub;
}

- (id)initWithParser:(CVAPIBlueprintParser *) blueprintParser {
  self = [super init];
  if (self) {
    _blueprintParser = blueprintParser;
    _rootNode = nil;
  }
  return self;
}

- (BOOL) isRequestStubbed:(NSURLRequest *)request {
  CVResponse *response = [self responseForRequest:request];
  
  if (nil == response) {
    return NO;
  }
  else {
    return YES;
  }
}


- (CVResponse *) responseForRequest:(NSURLRequest *)request {
  [self ensureParsed];
  
  __block CVResponse *foundResponse = nil;
  
  CVPathNode *startNode = self.rootNode;
  NSArray *pathComponents = [request.URL pathComponents];
  [pathComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *nodeName = (NSString *) obj;
    CVPathNode *newNode = [startNode.subNodes objectForKey:nodeName];
    if (nil == newNode && nil == startNode.paramNode) {
      *stop = YES;
    } else {
      if (nil == newNode) {
        newNode = startNode.paramNode;
      }
      foundResponse = newNode.response;      
    }
  }];

  return foundResponse;
}

- (void) ensureParsed {
  if (nil == self.rootNode) {
    self.rootNode = [self.blueprintParser parse];
  }
}

@end
