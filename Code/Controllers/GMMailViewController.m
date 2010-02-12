//
//  GMMailViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMMailViewController.h"
#import "GMAccount.h"
#import "GMSwitchAccountActionSheetDelegate.h"
#import "GMCreateAccountAlertDelegate.h"
#import "GMManageAccountActionSheetDelegate.h"
#import "UIAlertView_PrivateAPIs.h"
#import "GMWebViewDelegate.h"

@implementation GMMailViewController

@synthesize account = _account;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;

- (void)loadView {
	[super loadView];
	[self.navigationController setNavigationBarHidden:YES];
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460-44, 320, 44)];
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460 - 44)];
	GMWebViewDelegate* del = [[GMWebViewDelegate alloc] initWithGMMailViewController:self];
	[_webView setDelegate:del];
	[_webView setScalesPageToFit:YES];
	[self.view addSubview:_webView];
	[self.view addSubview:toolbar];
	
	UIBarButtonItem* addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountButtonWasPressed:)] autorelease];
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
	[toolbar setItems:[NSArray arrayWithObjects:_backButton, fixedSpace, _forwardButton, flexibleSpace, labelItem, flexibleSpace, switchButton, fixedSpace, addButton, nil]];
	
	// flip the back button so it points back.
	[[[toolbar subviews] objectAtIndex:0] setTransform:CGAffineTransformMake(-1, 0, 0, 1, 0, 0)];
	
	GMAccount* lastAccount = [GMAccount lastAccount];
	if (lastAccount) {
		[self switchToAccount:lastAccount];
	} else if ([[GMAccount allAccounts] count] > 0) {
		[self performSelector:@selector(switchAccountButtonWasPressed:) withObject:nil afterDelay:0.5];
	} else {
		[self performSelector:@selector(addAccountButtonWasPressed:) withObject:nil afterDelay:0.5];
	}
}

- (void)backButtonWasPressed:(id)sender {
	[_webView goBack];
}

- (void)forwardButtonWasPressed:(id)sender {
	[_webView goForward];
}

- (void)accountButtonWasPressed:(id)sender {
	GMManageAccountActionSheetDelegate* delegate = [[GMManageAccountActionSheetDelegate alloc] initWithGMMailViewController:self];
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Manage Account" delegate:delegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	[actionSheet showInView:self.view];
}

- (void)switchAccountButtonWasPressed:(id)sender {
	GMSwitchAccountActionSheetDelegate* delegate = [[GMSwitchAccountActionSheetDelegate alloc] initWithGMMailViewController:self];
	UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Switch To Account" delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
	NSArray* accounts = [GMAccount allAccounts];
	delegate.accounts = accounts;
	for (GMAccount* account in accounts) {
		[actionSheet addButtonWithTitle:[account name]];
	}
	if (sender) {
		[actionSheet addButtonWithTitle:@"Cancel"];
		[actionSheet setCancelButtonIndex:[accounts count]];
	}
	[actionSheet showInView:self.view];
}

- (void)addAccountButtonWasPressed:(id)sender {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Add GMail Account" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	[alertView addTextFieldWithValue:@"" label:@"Display Name"];
	[alertView addTextFieldWithValue:@"" label:@"Domain (e.g. twotoasters.com)"];
	UITextField* textField = [alertView textFieldAtIndex:1];
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	GMCreateAccountAlertDelegate* delegate = [[GMCreateAccountAlertDelegate alloc] initWithGMMailViewController:self];
	[alertView setDelegate:delegate];
	[alertView show];
	[alertView release];
}

- (void)switchToAccount:(GMAccount*)account {
	[GMAccount setLastAccount:account];
	
	[_webView stopLoading];
	
	[_accountButton setTitle:[account name] forState:UIControlStateNormal];
	[_accountButton sizeToFit];
	
	NSArray* newCookieDicts = [account cookieDicts];
	NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	[_account deleteAllCookieDicts];
	[_account saveCookies];
	
	for (NSDictionary* cookieDict in newCookieDicts) {
		NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:cookieDict];
		[cookieStorage setCookie:cookie];
	}
	
	if (_account) {
		[GMAccount addAccount:_account];
	}
	self.account = account;
	NSString* url = nil;
	if ([[account gmailAppsURL] isEqualToString:@"gmail.com"]) {
		url = @"http://mail.google.com";
	} else {
		url = [NSString stringWithFormat:@"http://mail.google.com/a/%@", [account gmailAppsURL]];
	}
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[_webView loadRequest:request];
}

@end
