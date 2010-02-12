//
//  GMDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMDelegate.h"


@implementation GMDelegate

- (id)initWithGMMailViewController:(GMMailViewController*)controller {
	if (self = [super init]) {
		_controller = controller;
	}
	return self;
}

@end
