//
//  CVAPIBlueprintStubsDemoTests.m
//  CVAPIBlueprintStubsDemoTests
//
//  Created by Kerem Karatal on 1/26/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <CVAPIBlueprintStubs/CVAPIBlueprintStub.h>

@interface CVAPIBlueprintStubsDemoTests : XCTestCase

@end

@implementation CVAPIBlueprintStubsDemoTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.

  CVAPIBlueprintStub *blueprintStub = [CVAPIBlueprintStub stubFromBlueprintAST:@"simplest_api"];
  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [blueprintStub isRequestStubbed:request];
  } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
    CVResponse *stubResponse = [blueprintStub responseForRequest:request];
    return [OHHTTPStubsResponse responseWithData:[stubResponse body]
                                      statusCode:(int)[stubResponse statusCode]
                                         headers:[stubResponse headers]];
  }];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void) testNSUrlConnectionBasedCall {
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/message"]];
  NSURLResponse *response = nil;
  NSError *error = nil;
  
  NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
  XCTAssertNotNil(data);
  
  NSString *body = [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
  XCTAssertTrue([body isEqualToString:@"Hello World!\n"]);
}

@end
