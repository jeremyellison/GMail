//
//  GMailControllerSpec.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "UIBug.h"
#import "UISpec.h"
#import "UIQuery.h"
#import "UIExpectation.h"

@interface GMailControllerSpec : NSObject <UISpec> {
	UIQuery* app;
}

@end
