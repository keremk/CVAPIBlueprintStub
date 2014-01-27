//
//  CVRequest.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>

@interface CVRequest : NSObject

@property(nonatomic, strong) NSString *urlTemplate;
@property(nonatomic, strong) NSDictionary *headers;
@property(nonatomic, strong) NSString *method;
@property(nonatomic, strong) NSDictionary *params;

- (NSUInteger) hash;
- (BOOL)isEqual:(id)anObject;

- (id)copyWithZone:(NSZone *)zone;

@end
