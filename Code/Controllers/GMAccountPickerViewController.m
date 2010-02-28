//
//  GMAccountPickerViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/19/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GMAccountPickerViewController.h"
#import "GMAccount.h"

@interface GMLauncherItem : TTLauncherItem {
	GMAccount* _account;
}
@property (nonatomic, retain) GMAccount* account;

@end

@implementation GMLauncherItem

@synthesize account = _account;

@end

@implementation GMAccountPickerViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_addButton release];
	[_editButton release];
	[_accountsToDelete release];
	[_launcher release];
	[super dealloc];
}

- (void)setupLauncher {
	NSMutableArray* pages = [NSMutableArray array];
	for (GMAccount* account in [GMAccount allAccounts]) {
		while ([pages count] <= [account.page intValue]) {
			[pages addObject:[NSMutableArray array]];
		}
		GMLauncherItem* item = [[GMLauncherItem alloc] initWithTitle:account.name
															   image:[GMAccount iconForAccount:account]
																 URL:[NSString stringWithFormat:@"gg://account/%@/%@", account.page, account.order]
														   canDelete:YES];
		item.account = account;
		[[pages objectAtIndex:[account.page intValue]] addObject:item];
	}
	[_launcher setPages:pages];
	_launcher.delegate = self;
}

- (void)setupLauncherAndSelectAccount:(GMAccount*)account {
	[self setupLauncher];
	NSString* url = [NSString stringWithFormat:@"gg://account/%@/%@", account.page, account.order];
	[_launcher scrollToItem:[_launcher itemWithURL:url] animated:YES];
}

- (void)accountAdded:(NSNotification*)notification {
	[self setupLauncherAndSelectAccount:(GMAccount*)notification.object];
}

- (void)loadView {
	[super loadView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountAdded:) name:@"CreatedAccount" object:nil];
	
	_accountsToDelete = [[NSMutableArray alloc] init];
	
	self.title = @"Accounts";
	self.view.backgroundColor = [UIColor blackColor];
	
	_launcher = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	[self setupLauncher];
	[_launcher setCurrentPageIndex:0];
	[self.view addSubview:_launcher];
	
	_editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonWasPressed:)];
	self.navigationItem.leftBarButtonItem = _editButton;
	
	_addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountButtonWasPressed:)];
	self.navigationItem.rightBarButtonItem = _addButton;
}

- (void)addAccountButtonWasPressed:(id)sender {
	TTOpenURL(@"gm://choseAccountType");
}


- (void)editButtonWasPressed:(id)sender {
	if ([_launcher editing]) {
		[_launcher endEditing];
		[self setupLauncher];
	} else {
		[_launcher beginEditing];
	}
}

- (void)doneButtonWasPressed:(id)sender {
	[_launcher endEditing];
	[self.navigationItem setRightBarButtonItem:_addButton animated:YES];
	
	int p = 0;
	for (NSMutableArray* page in _launcher.pages) {
		int i = 0;
		for (GMLauncherItem* item in page) {
			item.account.order = [NSNumber numberWithInt:i];
			item.account.page = [NSNumber numberWithInt:p];
			i++;
		}
		p++;
	}
	
	for (GMAccount* account in _accountsToDelete) {
		[GMAccount deleteAccount:account];
	}
}

- (void)launcherView:(TTLauncherView*)launcher didRemoveItem:(GMLauncherItem*)item {
	[launcher removeItem:item animated:YES];
	[_accountsToDelete addObject:item.account];
}

- (void)launcherView:(TTLauncherView*)launcher didMoveItem:(GMLauncherItem*)item {
	
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(GMLauncherItem*)item {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PickedAccount" object:item.account];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonWasPressed:)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButton animated:YES];
	UIBarButtonItem* editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonWasPressed:)] autorelease];
	[self.navigationItem setLeftBarButtonItem:editButton animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:_addButton animated:YES];
	[self.navigationItem setLeftBarButtonItem:_editButton animated:YES];
	_editButton.title = @"Edit";
}

@end
