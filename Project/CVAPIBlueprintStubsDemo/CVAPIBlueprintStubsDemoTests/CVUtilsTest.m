//
//  CVUtilsTest.m
//  CVAPIBlueprintStubsDemo
//
//  Created by Kerem Karatal on 1/28/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CVAPIBlueprintStubs/CVUtils.h>

@interface CVUtilsTest : XCTestCase

@end

@implementation CVUtilsTest

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testPathStringForNoQueryParams {
  NSString *pathString = @"message";
  
  NSString *newPathString = [CVUtils stripQueryParamIfExistsFromPathString:pathString];
  XCTAssertTrue([newPathString isEqualToString: @"message"]);
}

- (void) testPathStringForQueryParams {
  NSString *pathString = @"messages{?limit}";
  
  NSString *newPathString = [CVUtils stripQueryParamIfExistsFromPathString:pathString];
  XCTAssertTrue([newPathString isEqualToString: @"messages"]);
}

- (void) testCheckingForRootNode {
  NSString *pathString = @"/";
  
  NSString *newPathString = [CVUtils stripQueryParamIfExistsFromPathString:pathString];
  XCTAssertTrue([newPathString isEqualToString: @"/"]);
  XCTAssertEqualObjects(newPathString, @"/");
}

- (void) testCheckingForParamNode {
  NSString *pathString = @"{12}";
  
  BOOL isParamNode = [CVUtils isParamNodeFromPathString:pathString];
  XCTAssertTrue(isParamNode);
}


@end
