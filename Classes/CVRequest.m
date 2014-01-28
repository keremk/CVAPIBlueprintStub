//
//  CVRequest.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVRequest.h"

@implementation CVRequest

- (id) initWithURLRequest:(NSURLRequest *) urlRequest {
  self = [super init];
  if (self) {
    _useHeaderValues = YES;
    _useParamsValues = YES;
    _method = [urlRequest HTTPMethod];
    _params = [self paramsFromURL:urlRequest.URL];
    _headers = [urlRequest allHTTPHeaderFields];
  }
  return self;
}

- (NSDictionary *) paramsFromURL:(NSURL *) url {
  __block NSMutableDictionary *params = nil;
  
  NSArray *queryParams = [url.query componentsSeparatedByString:@"&"];
  [queryParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *paramString = (NSString *) obj;
    NSArray *paramComponents = [paramString componentsSeparatedByString:@"="];
    if (paramComponents && [paramComponents count] == 2) {
      [params setObject:[paramComponents objectAtIndex:1] forKey:[paramComponents objectAtIndex:0]];
    }
  }];
  
  return params;
}

- (NSUInteger) hash {
  NSString *paramsString = [self dictionaryToString:self.params usingValues:self.useParamsValues];
  NSString *headerString = [self dictionaryToString:self.headers usingValues:self.useHeaderValues];
  return [self.method hash] ^ [headerString hash] ^ [paramsString hash];
}

- (BOOL)isEqual:(id)anObject {
  if (self == anObject) {
    return YES;
  }
  
  if (![anObject isKindOfClass:[CVRequest class]]) {
    return NO;
  }
  
  CVRequest *otherRequest = (CVRequest *) anObject;
  
  return [otherRequest isEqualToCVRequest:self];
}

- (id)copyWithZone:(NSZone *)zone {
  CVRequest *objectCopy = [[CVRequest allocWithZone:zone] init];
  objectCopy.method = self.method;
  objectCopy.params = [self.params copy];
  objectCopy.headers = [self.headers copy];
  return objectCopy;
}

- (BOOL) isEqualToCVRequest:(CVRequest *) anObject {
  BOOL isMethodEqual = [self.method isEqualToString:anObject.method];
  BOOL areParamsEqual = [self.params isEqualToDictionary:anObject.params];
  BOOL areHeadersEqual = [self.headers isEqualToDictionary:anObject.headers];
  
  return isMethodEqual && areParamsEqual && areHeadersEqual;
}

- (NSString *) dictionaryToString:(NSDictionary *) dict usingValues:(BOOL) useValues{
  NSMutableString *output = [[NSMutableString alloc] init];

  [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSString *keyString = (NSString *)key;
    NSString *keyValueString = @"";
    if (useValues) {
      NSString *objString = (NSString *)obj;
      keyValueString = [NSString stringWithFormat:@"%@&%@", keyString, objString];
    } else {
      keyValueString = [NSString stringWithFormat:@"%@-", keyString];
    }
    [output appendString:keyValueString];
  }];
  return output;
}


@end
