//
//  CVResponse.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>

@interface CVResponse : NSObject

@property(nonatomic, strong) NSData *body;
@property(nonatomic) NSInteger statusCode;
@property(nonatomic, strong) NSDictionary *headers;

@end
