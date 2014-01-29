//
//  CVUtils.h
//  
//
//  Created by Kerem Karatal on 1/28/14.
//
//

#import <Foundation/Foundation.h>

@interface CVUtils : NSObject
+ (NSString *) stripQueryParamIfExistsFromPathString:(NSString *) pathString;
+ (BOOL) isParamNodeFromPathString:(NSString *) pathString;
@end
