//
//  GMCreateAccountTableViewController.h
//  GMail
//
//  Created by Jeremy Ellison on 2/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Three20/Three20.h>


@interface GMCreateAccountTableViewController : TTTableViewController {
	NSString* _accountType;
	UITextField* _nameField;
	UITextField* _urlField;
}

@end
