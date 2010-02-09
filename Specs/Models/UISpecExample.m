//
//  UISpecExample.m
//  GMail
//
//  Created by Jeremy Ellison on 11/17/09.
//  Copyright 2009 Objective3. All rights reserved.
//


#import "UIBug.h"
#import "UISpec.h"
#import "UIQuery.h"
#import "UIExpectation.h"
#import "TWTExpectation.h"

@interface UISpecExample : NSObject <UISpec> {
	UIQuery* app;
}

@end

@implementation UISpecExample

- (void)beforeAll {
	app = [[UIQuery withApplicaton] retain];
}

-(void)afterAll {
	[app release];
}

- (void)itShouldViewUI {
	[[app view] should].exist;
}

@end
