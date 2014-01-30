//
//  CVRequest.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>

@interface CVRequest : NSObject<NSCopying>

@property(nonatomic, strong) NSDictionary *headers;
@property(nonatomic, strong) NSString *method;
@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic) BOOL useParamsValues;

- (id) initWithURLRequest:(NSURLRequest *) urlRequest useParamsValues:(BOOL) useParamsValues;
- (NSUInteger) hash;
- (BOOL)isEqual:(id)anObject;
- (id)copyWithZone:(NSZone *)zone;

@end
