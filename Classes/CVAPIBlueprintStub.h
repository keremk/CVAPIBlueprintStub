//
//  CVAPIBlueprintStub.h
//  
//
//  Created by Kerem Karatal on 1/26/14.
//
//

#import <Foundation/Foundation.h>
#import "CVResponse.h"

@interface CVAPIBlueprintStub : NSObject

+ (CVAPIBlueprintStub *) stubFromBlueprintAST:(NSString *) blueprintASTFilename;

- (BOOL) isRequestStubbed:(NSURLRequest *)request;
- (CVResponse *) responseForRequest:(NSURLRequest *) request;
@end
