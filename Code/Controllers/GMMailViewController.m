//
//  GMMailViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMMailViewController.h"
#import "GMAccount.h"

@interface UIAlertView (PrivateAPIs)
- (UITextField*)addTextFieldWithValue:(NSString*)value label:(NSString*)label;
- (UITextField*)textFieldAtIndex:(NSUInteger)index;
- (NSUInteger)textFieldCount;
- (UITextField*)textField;
@end


@implementation GMMailViewController

@synthesize account = _account;

- (void)loadView {
	[super loadView];
	[self.navigationController setNavigationBarHidden:YES];
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460-44, 320, 44)];
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460 - 44)];
	[_webView setDelegate:self];
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
	
	[toolbar setItems:[NSArray arrayWithObjects:switchButton, flexibleSpace, labelItem, flexibleSpace, addButton, nil]];
	
	GMAccount* lastAccount = [GMAccount lastAccount];
	if (lastAccount) {
		[self switchToAccount:lastAccount];
	} else if ([[GMAccount allAccounts] count] > 0) {
		[self performSelector:@selector(switchAccountButtonWasPressed:) withObject:nil afterDelay:0.5];
	} else {
		[self performSelector:@selector(addAccountButtonWasPressed:) withObject:nil afterDelay:0.5];
	}
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
	for (NSHTTPCookie* cookie in [cookieStorage cookies]) {
		[_account addCookieDict:[cookie properties]];
		[cookieStorage deleteCookie:cookie];
	}
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	NSLog(@"Loaded: %@", [[webView request] URL]);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[webView isLoading]];
	// if the request URL contains "ServiceLogin", we should try to log them in. when we get there.
}

@end

@implementation GMDelegate

- (id)initWithGMMailViewController:(GMMailViewController*)controller {
	if (self = [super init]) {
		_controller = controller;
	}
	return self;
}

@end

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