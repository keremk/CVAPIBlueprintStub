//
//  CVAPIBlueprintStub.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVAPIBlueprintStub.h"
#import "CVAPIBlueprintParser.h"

@interface CVAPIBlueprintStub()
@property(nonatomic, strong) CVAPIBlueprintParser *blueprintParser;
@property(nonatomic, strong) NSDictionary *stubbedRequests;

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
    _stubbedRequests = nil;
  }
  return self;
}

- (BOOL) isRequestStubbed:(NSURLRequest *)request {
  [self ensureParsed];
  CVRequest *cvRequest = [self.blueprintParser createRequestFromURLRequest:request];
  CVResponse *response = [self.stubbedRequests objectForKey:cvRequest];
  
  if (response == nil) {
    return NO;
  }
  else {
    return YES;
  }
}

- (CVResponse *) responseForRequest:(NSURLRequest *)request {
  CVRequest *cvRequest = [self.blueprintParser createRequestFromURLRequest:request];
  CVResponse *response = [self.stubbedRequests objectForKey:cvRequest];
  
  return response;
}


- (void) ensureParsed {
  if (self.stubbedRequests == nil) {
    self.stubbedRequests = [self.blueprintParser parse];
  }
}

@end
