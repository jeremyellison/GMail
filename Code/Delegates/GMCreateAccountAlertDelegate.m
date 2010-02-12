//
//  GMCreateAccountAlertDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMCreateAccountAlertDelegate.h"
#import "GMAccount.h"
#import "UIAlertView_PrivateAPIs.h"

@implementation GMCreateAccountAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (1 == buttonIndex) {
		NSString* name = [[alertView textFieldAtIndex:0] text];
		NSString* url = [[alertView textFieldAtIndex:1] text];
		GMAccount* account = [[[GMAccount alloc] initWithName:name URL:url] autorelease];
		[GMAccount addAccount:account];
		[_controller switchToAccount:account];
	}
	[self release];
}

@end
