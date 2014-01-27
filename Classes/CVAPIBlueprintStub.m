//
//  CVAPIBlueprintStub.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVAPIBlueprintStub.h"

@interface CVAPIBlueprintStub()
@property(nonatomic, strong) NSDictionary *blueprintAST;

- (id)initWithAST:(NSDictionary *) blueprintAST;
@end

@implementation CVAPIBlueprintStub

+ (CVAPIBlueprintStub *) stubFromBlueprintAST:(NSString *) blueprintASTFilename {
  NSString *filePath = [[NSBundle bundleForClass: [CVAPIBlueprintStub class]] pathForResource:blueprintASTFilename ofType:@"json"];
  NSError *error;
  NSData *jsonASTData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  NSDictionary *blueprintAST = [NSJSONSerialization JSONObjectWithData:jsonASTData
                                                               options:kNilOptions
                                                                 error:&error];
  
  CVAPIBlueprintStub *stub = [[CVAPIBlueprintStub alloc] initWithAST:blueprintAST];
  return stub;
}

- (id)initWithAST:(NSDictionary *) blueprintAST {
  self = [super init];
  if (self) {
    _blueprintAST = blueprintAST;
  }
  return self;
}

- (BOOL) isRequestStubbed:(NSURLRequest *)request {
  return YES;
}

- (CVResponse *) responseForRequest:(NSURLRequest *)request {
  CVResponse *response = [[CVResponse alloc] init];
  
  return response;
}


@end
