//
//  GMSwitchAccountActionSheetDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMSwitchAccountActionSheetDelegate.h"


@implementation GMSwitchAccountActionSheetDelegate

@synthesize accounts = _accounts;

- (void)dealloc {
	[_accounts release];
	[super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex < [_accounts count]) {
		[_controller switchToAccount:[_accounts objectAtIndex:buttonIndex]];
	}
	[self release];
}

@end
