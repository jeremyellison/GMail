//
//  GMMailViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMMailViewController.h"
#import "GMAccount.h"
#import "UIAlertView_PrivateAPIs.h"
#import "GMWebViewDelegate.h"

@implementation GMMailViewController

@synthesize account = _account;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickAccount:) name:@"PickedAccount" object:nil];
	
	[self.navigationController setNavigationBarHidden:YES];
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460-44, 320, 44)];
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460 - 44)];
	GMWebViewDelegate* del = [[GMWebViewDelegate alloc] initWithGMMailViewController:self];
	[_webView setDelegate:del];
	[_webView setScalesPageToFit:YES];
	[self.view addSubview:_webView];
	[self.view addSubview:toolbar];
	
	UIBarButtonItem* switchButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(switchAccountButtonWasPressed:)] autorelease];
	_accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_accountButton.backgroundColor = [UIColor clearColor];
	[_accountButton setTitle:@"No Account Selected" forState:UIControlStateNormal];
	[_accountButton sizeToFit];
	[_accountButton addTarget:self action:@selector(accountButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem* labelItem = [[[UIBarButtonItem alloc] initWithCustomView:_accountButton] autorelease];
	UIBarButtonItem* flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	_backButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(backButtonWasPressed:)] autorelease];
	[_backButton setEnabled:NO];
	_forwardButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(forwardButtonWasPressed:)] autorelease];
	[_forwardButton setEnabled:NO];
	UIBarButtonItem* fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	[fixedSpace setWidth:10];
	[toolbar setItems:[NSArray arrayWithObjects:_backButton, fixedSpace, _forwardButton, flexibleSpace, labelItem, flexibleSpace, switchButton, fixedSpace, nil]];
	
	// flip the back button so it points back.
	[[[toolbar subviews] objectAtIndex:0] setTransform:CGAffineTransformMake(-1, 0, 0, 1, 0, 0)];
	
	GMAccount* lastAccount = [GMAccount lastAccount];
	if (lastAccount) {
		[self switchToAccount:lastAccount];
	} else if ([[GMAccount allAccounts] count] > 0) {
		[self performSelector:@selector(switchAccountButtonWasPressed:) withObject:nil afterDelay:0.5];
	} else {
		[[TTNavigator navigator] openURLs:@"gm://choseAccount", @"gm://choseAccountType", nil];
	}
}

- (void)pickAccount:(NSNotification*)notification {
	[self switchToAccount:notification.object];
}

- (void)backButtonWasPressed:(id)sender {
	[_webView goBack];
}

- (void)forwardButtonWasPressed:(id)sender {
	[_webView goForward];
}

- (void)accountButtonWasPressed:(id)sender {
	
}

- (void)switchAccountButtonWasPressed:(id)sender {
	TTOpenURL(@"gm://choseAccount");
}

- (void)switchToAccount:(GMAccount*)account {
	[GMAccount setLastAccount:account];
	
	[_webView stopLoading];
	
	[_accountButton setTitle:[account name] forState:UIControlStateNormal];
	[_accountButton sizeToFit];
	
	[_account saveCookies];
	[account setupCookies];

	self.account = account;
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[account url]]];
	[_webView loadRequest:request];
}

@end
