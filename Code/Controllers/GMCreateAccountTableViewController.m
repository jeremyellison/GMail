//
//  GMCreateAccountTableViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GMCreateAccountTableViewController.h"
#import "GMAccount.h"

@implementation GMCreateAccountTableViewController

- (id)initWithAccountType:(NSString*)accountType {
	if (self = [self initWithStyle:UITableViewStyleGrouped]) {
		_accountType = [accountType retain];
		_nameField = nil;
		_urlField = nil;
	}
	return self;
}

- (void)dealloc {
	[_accountType release];
	[_nameField release];
	[_urlField release];
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	self.title = _accountType;
}

- (void)createModel {
	NSMutableArray* items = [NSMutableArray array];
	_nameField = [[UITextField alloc] initWithFrame:CGRectZero];
	_nameField.placeholder = @"Two Toasters";
	[items addObject:[TTTableControlItem itemWithCaption:@"Name" control:_nameField]];
	if ([GMAccount accountTypeRequiresAppsURL:_accountType]) {
		_urlField = [[UITextField alloc] initWithFrame:CGRectZero];
		_urlField.placeholder = @"twotoasters.com";
		[items addObject:[TTTableControlItem itemWithCaption:@"Domain" control:_urlField]];
	}
	[items addObject:[TTTableButton itemWithText:@"Create Account"]];
	self.dataSource = [TTListDataSource dataSourceWithItems:items];
}

- (GMAccount*)saveAccount {
	GMAccount* account = [[[GMAccount alloc] initWithName:[_nameField text] 
													  URL:[_urlField text]
											  accountType:_accountType] autorelease];
	[GMAccount addAccount:account];
	return account;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	if ([object isKindOfClass:[TTTableButton class]]) {
		GMAccount* account = [self saveAccount];
		[self dismissModalViewControllerAnimated:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CreatedAccount" object:account];
	}
}

@end
