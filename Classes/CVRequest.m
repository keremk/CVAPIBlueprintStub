//
//  CVRequest.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVRequest.h"

@implementation CVRequest

- (id) init {
  self = [super init];
  if (self) {
    self.useParamsValues = NO;
  }
  return self;
}

- (id) initWithURLRequest:(NSURLRequest *) urlRequest useParamsValues:(BOOL) useParamsValues{
  self = [super init];
  if (self) {
    self.useParamsValues = useParamsValues;
    self.method = [urlRequest HTTPMethod];
    self.params = [self paramsFromURL:urlRequest.URL];
    self.headers = [urlRequest allHTTPHeaderFields];
    if (nil == self.headers) {
      self.headers = [NSDictionary dictionary];
    }
  }
  return self;
}

- (NSDictionary *) paramsFromURL:(NSURL *) url {
  __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
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

- (void) setParams:(NSDictionary *)params {
  if (_useParamsValues) {
    _params = params;
  } else {
    _params = [NSMutableDictionary dictionary];
   [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
     [_params setValue:@"" forKey:key];
   }];
  }
}

- (NSUInteger) hash {
  NSString *paramsString = nil;
  if ([self.params count] > 0) {
    paramsString = [self dictionaryToString:self.params usingValues:self.useParamsValues];
  } else {
    paramsString = @"no-params";
  }
  NSString *headerString;
  if ([self.headers count] > 0) {
    headerString = [self dictionaryToString:self.headers usingValues:NO];
  } else {
    headerString = @"no-headers";
  }
  NSString *hashString = [NSString stringWithFormat:@"%@-%@-%@", self.method, headerString, paramsString];
  return [hashString hash];
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
