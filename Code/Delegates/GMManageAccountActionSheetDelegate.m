//
//  GMManageAccountActionSheetDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMManageAccountActionSheetDelegate.h"
#import "GMAccount.h"

@implementation GMManageAccountActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Index: %d", buttonIndex);
	if (0 == buttonIndex) {
		//delete
		[GMAccount deleteAccount:_controller.account];
		_controller.account = nil;
		[_controller switchAccountButtonWasPressed:nil];//nil tells it we can't cancel.
	}
	[self release];
}

@end