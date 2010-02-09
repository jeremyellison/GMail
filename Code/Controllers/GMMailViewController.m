//
//  GMMailViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMMailViewController.h"
#import "GMAccount.h"

@implementation GMMailViewController

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
//	_accountButton.textColor = [UIColor whiteColor];
	_accountButton.backgroundColor = [UIColor clearColor];
//	_accountButton.font = [UIFont boldSystemFontOfSize:18];
	[_accountButton setTitle:@"No Account Selected" forState:UIControlStateNormal];
	[_accountButton sizeToFit];
	UIBarButtonItem* labelItem = [[[UIBarButtonItem alloc] initWithCustomView:_accountButton] autorelease];
	UIBarButtonItem* flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	[toolbar setItems:[NSArray arrayWithObjects:switchButton, flexibleSpace, labelItem, flexibleSpace, addButton, nil]];
	
	[self performSelector:@selector(switchAccountButtonWasPressed:) withObject:nil afterDelay:0.5];
}

- (void)switchAccountButtonWasPressed:(id)sender {
	UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Switch To Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
	NSArray* accounts = [GMAccount allAccounts];
	for (GMAccount* account in accounts) {
		[actionSheet addButtonWithTitle:[account gmailAppsURL]];
	}
	if (sender) {
		[actionSheet addButtonWithTitle:@"Cancel"];
		[actionSheet setCancelButtonIndex:[accounts count]];
	}
	[actionSheet showInView:self.view];
}

- (void)addAccountButtonWasPressed:(id)sender {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 15.0, 260.0, 25.0)];
	textField.tag = 999;
	[textField setBorderStyle:UITextBorderStyleLine];
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	textField.backgroundColor = [UIColor whiteColor];
	[alertView addSubview:textField];
	GMCreateAccountAlertDelegate* delegate = [[GMCreateAccountAlertDelegate alloc] initWithController:self];
	[alertView setDelegate:delegate];
	[alertView show];
	[alertView release];
}

- (void)switchToAccount:(GMAccount*)account {
	[_webView stopLoading];
	
	[_accountButton setTitle:[account gmailAppsURL] forState:UIControlStateNormal];
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
	[_account release];
	_account = [account retain];
	NSString* url = nil;
	if ([[account gmailAppsURL] isEqualToString:@"gmail.com"]) {
		url = @"http://mail.google.com";
	} else {
		url = [NSString stringWithFormat:@"http://mail.google.com/a/%@", [account gmailAppsURL]];
	}
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[_webView loadRequest:request];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"Cancel"]) {
		return;
	}
	NSArray* accounts = [GMAccount allAccounts];
	GMAccount* accountToSwitchTo = nil;
	for (GMAccount* account in accounts) {
		if ([[account gmailAppsURL] isEqualToString:buttonTitle]) {
			accountToSwitchTo = account;
			break;
		}
	}
	
	[self switchToAccount:accountToSwitchTo];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[webView isLoading]];
}

@end


@implementation GMCreateAccountAlertDelegate

- (id)initWithController:(GMMailViewController*)controller {
	if (self = [super init]) {
		_controller = controller;
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (1 == buttonIndex) {
		UITextField* textField = (UITextField*)[alertView viewWithTag:999];
		GMAccount* account = [[[GMAccount alloc] initWithURL:[textField text] cookies:[NSArray array]] autorelease];
		[GMAccount addAccount:account];
		[_controller switchToAccount:account];
	}
	[self release];
}

@end