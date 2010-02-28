//
//  GMAccountPickerViewController.h
//  GMail
//
//  Created by Jeremy Ellison on 2/19/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Three20/Three20.h>


@interface GMAccountPickerViewController : TTViewController <TTLauncherViewDelegate> {
	TTLauncherView* _launcher;
	NSMutableArray* _accountsToDelete;
	UIBarButtonItem* _addButton;
	UIBarButtonItem* _editButton;
}

@end
