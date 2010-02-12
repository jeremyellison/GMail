//
//  GMDelegate.h
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMMailViewController.h"

@interface GMDelegate : NSObject {
	GMMailViewController* _controller;
}

- (id)initWithGMMailViewController:(GMMailViewController*)controller;

@end
