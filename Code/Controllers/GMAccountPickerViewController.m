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

- (void)setupLauncher {
	NSMutableArray* pages = [NSMutableArray array];
	for (GMAccount* account in [GMAccount allAccounts]) {
		while ([pages count] <= [account.page intValue]) {
			[pages addObject:[NSMutableArray array]];
		}
		GMLauncherItem* item = [[GMLauncherItem alloc] initWithTitle:account.name
															   image:[GMAccount iconForAccount:account]
																 URL:[NSString stringWithFormat:@"gg://account/%@", account.order]
														   canDelete:YES];
		item.account = account;
		[[pages objectAtIndex:[account.page intValue]] addObject:item];
	}
	[_launcher setPages:pages];
	_launcher.delegate = self;
}

- (void)loadView {
	[super loadView];
	
	_accountsToDelete = [[NSMutableArray alloc] init];
	
	self.title = @"Accounts";
	self.view.backgroundColor = [UIColor blackColor];
	
	_launcher = [[[TTLauncherView alloc] initWithFrame:self.view.bounds] autorelease];
	[self setupLauncher];
	[_launcher setCurrentPageIndex:0];
	[self.view addSubview:_launcher];
	
	UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancel {
	if ([_launcher editing]) {
		[_launcher endEditing];
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
		[self setupLauncher];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)done {
	[_launcher endEditing];
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
	
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
	UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButton animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	
}

@end
