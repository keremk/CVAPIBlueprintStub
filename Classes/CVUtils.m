//
//  CVUtils.m
//  
//
//  Created by Kerem Karatal on 1/28/14.
//
//

#import "CVUtils.h"

@implementation CVUtils

+ (NSString *) stripQueryParamIfExistsFromPathString:(NSString *) pathString {
  NSError *error = NULL;
  NSRegularExpression *queryParamRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\w+)|(\\{\\?\\w*\\})"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
  
  NSArray *matches = [queryParamRegex matchesInString:pathString options:0 range:NSMakeRange(0, [pathString length])];
  if ([matches count] == 2) {
    return [matches objectAtIndex:0];
  } else {
    return pathString;
  }
}

+ (BOOL) isParamNodeFromPathString:(NSString *) pathString {
  NSError *error = NULL;
  NSRegularExpression *pathParamRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{.\\}"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error];
  NSUInteger numberOfMatches = [pathParamRegex numberOfMatchesInString:pathString
                                                               options:0
                                                                 range:NSMakeRange(0, [pathString length])];
  
  BOOL isParamString = NO;
  if (numberOfMatches > 0) {
    isParamString = YES;
  }
  return isParamString;
}

@end
