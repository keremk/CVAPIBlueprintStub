//
//  CVAPIBluePrintParserTest.m
//  CVAPIBlueprintStubsDemo
//
//  Created by Kerem Karatal on 1/28/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CVAPIBlueprintStubs/CVAPIBlueprintParser.h>

@interface CVAPIBluePrintParserTest : XCTestCase

@end

@implementation CVAPIBluePrintParserTest

- (NSDictionary *) loadFromFile:(NSString *) filename {
  NSString *filePath = [[NSBundle bundleForClass: [CVAPIBluePrintParserTest class]] pathForResource:filename ofType:@"json"];
  NSError *error;
  NSData *jsonASTData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  NSDictionary *blueprintAST = [NSJSONSerialization JSONObjectWithData:jsonASTData
                                                               options:kNilOptions
                                                                 error:&error];
  return blueprintAST;
}

- (void) setUp {
  [super setUp];
  // Put setup code here; it will be run once, before the first test case.
}

- (void) tearDown {
  // Put teardown code here; it will be run once, after the last test case.
  [super tearDown];
}

- (void) testParsingASTForSimplestCase {
  NSDictionary *blueprintAST = [self loadFromFile:@"simplest_api"];
  CVAPIBlueprintParser *parser = [[CVAPIBlueprintParser alloc] initWithAST:blueprintAST];
  [parser processAST];
  XCTAssertNotNil(parser.rootNode);
  NSInteger subNodeCount = [parser.rootNode.subNodes count];
  XCTAssertEqual(subNodeCount, 1); // message node
  CVPathNode *messageNode = [parser.rootNode.subNodes objectForKey:@"message"];
  XCTAssertNotNil(messageNode);
  NSDictionary *allResponses = [messageNode allResponses];
  NSInteger responseCount = [allResponses count];
  XCTAssertEqual(responseCount, 1);
}

- (void) testParsingASTForMultipleResponses {
  NSDictionary *blueprintAST = [self loadFromFile:@"responses"];
  CVAPIBlueprintParser *parser = [[CVAPIBlueprintParser alloc] initWithAST:blueprintAST];
  [parser processAST];
  XCTAssertNotNil(parser.rootNode);
}

- (void) testParsingASTWith3DeepAndParamsNode {
  NSDictionary *blueprintAST = [self loadFromFile:@"parameters"];
  CVAPIBlueprintParser *parser = [[CVAPIBlueprintParser alloc] initWithAST:blueprintAST];
  [parser processAST];
  XCTAssertNotNil(parser.rootNode);
  CVPathNode *subNode = [parser.rootNode.subNodes objectForKey:@"message"];
  XCTAssertNotNil(subNode);
  CVPathNode *paramNode = subNode.paramNode;
  XCTAssertNotNil(paramNode);
  XCTAssertEqualObjects(paramNode.pathString, @"{id}");
  NSDictionary *responses = [paramNode allResponses];
  NSInteger count = [responses count];
  XCTAssertEqual(count, 3);
}

- (void) testFindingResponseForAGivenURLRequest {
  NSDictionary *blueprintAST = [self loadFromFile:@"simplest_api"];
  CVAPIBlueprintParser *parser = [[CVAPIBlueprintParser alloc] initWithAST:blueprintAST];
  NSURL *url = [NSURL URLWithString:@"http://example.com/message"];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  CVResponse *response = [parser responseForRequest:urlRequest];
  XCTAssertNotNil(response);
}

- (void) testFindingResponseForAGivenURLRequestWithParameters {
  NSDictionary *blueprintAST = [self loadFromFile:@"parameters"];
  CVAPIBlueprintParser *parser = [[CVAPIBlueprintParser alloc] initWithAST:blueprintAST];
  NSURL *url = [NSURL URLWithString:@"http://example.com/messages?limit=10"];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  CVResponse *response = [parser responseForRequest:urlRequest];
  XCTAssertNotNil(response);
}

@end
