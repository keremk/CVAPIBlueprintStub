//
//  CVRequest.m
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import "CVRequest.h"

@implementation CVRequest

- (NSUInteger) hash {
  return [self.urlTemplate hash] ^ [self.method hash] ^ [[self dictionaryToString:self.params] hash] ^ [[self dictionaryToString:self.headers] hash];
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
  objectCopy.urlTemplate = self.urlTemplate;
  objectCopy.method = self.method;
  objectCopy.params = [self.params copy];
  objectCopy.headers = [self.headers copy];
  return objectCopy;
}

- (BOOL) isEqualToCVRequest:(CVRequest *) anObject {
  BOOL isUrlTemplateEqual = [self.urlTemplate isEqualToString:anObject.urlTemplate];
  BOOL isMethodEqual = [self.method isEqualToString:anObject.method];
  BOOL areParamsEqual = [self.params isEqualToDictionary:anObject.params];
  BOOL areHeadersEqual = [self.headers isEqualToDictionary:anObject.headers];
  
  return isUrlTemplateEqual && isMethodEqual && areParamsEqual && areHeadersEqual;
}

- (NSString *) dictionaryToString:(NSDictionary *) dict {
  NSMutableString *output = [[NSMutableString alloc] init];

  [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSString *keyString = (NSString *)key;
    NSString *objString = (NSString *)obj;
    NSString *keyValueString = [NSString stringWithFormat:@"%@&%@", keyString, objString];
    [output appendString:keyValueString];
  }];
  return output;
}


@end
