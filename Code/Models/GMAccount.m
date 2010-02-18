//
//  GMAccount.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMAccount.h"


@implementation GMAccount

static NSString* accountsKey = @"kGMailAccountsKey";
static NSString* lastAccountKey = @"kGMailLastAccountKey";

+ (NSArray*)accountTypes {
	return [NSArray arrayWithObjects:@"Google Apps", @"GMail", @"Yahoo! Mail", @"Hotmail", nil];
}

+ (BOOL)accountTypeRequiresAppsURL:(NSString*)accountType {
	return [accountType isEqualToString:@"Google Apps"];
}

+ (NSString*)domainForAccountType:(NSString*)accountType {
	return [[NSDictionary dictionaryWithObjectsAndKeys:
			 @"http://mail.google.com/a", @"Google Apps",
			 @"http://mail.google.com", @"GMail",
			 @"http://m.yahoo.com/mail", @"Yahoo! Mail",
			 @"http://hotmail.com", @"Hotmail", nil] objectForKey:accountType];
}

- (NSString*)url {
	if ([GMAccount accountTypeRequiresAppsURL:_accountType]) {
		return [NSString stringWithFormat:@"%@/%@", [GMAccount domainForAccountType:_accountType], _gmailAppsURL];
	}
	return [GMAccount domainForAccountType:_accountType];
}

+ (void)setLastAccount:(GMAccount*)account {
	[[NSUserDefaults standardUserDefaults] setObject:[account name] forKey:lastAccountKey];
}

+ (GMAccount*)lastAccount {
	NSString* key = [[NSUserDefaults standardUserDefaults] objectForKey:lastAccountKey];
	for (GMAccount* account in [self allAccounts]) {
		if ([key isEqualToString:[account name]]) {
			return account;
		}
	}
	return nil;
}

+ (NSArray*)allAccounts {
	// This is stored as a key/val store. url => cookies
	NSDictionary* accountsDict = [[NSUserDefaults standardUserDefaults] objectForKey:accountsKey];
	NSMutableArray* allAccounts = [NSMutableArray arrayWithCapacity:[[accountsDict allKeys] count]];
	for (NSString* key in [accountsDict allKeys]) {
		//GMAccount* account = [[[self alloc] initWithURL:key cookies:[accountsDict objectForKey:key]] autorelease];
		NSArray* array = [accountsDict objectForKey:key];
		GMAccount* account = [[[self alloc] initWithName:key URL:[array objectAtIndex:0] cookies:[array objectAtIndex:1] accountType:[array objectAtIndex:2]] autorelease];
		[allAccounts addObject:account];
	}
	return allAccounts;
}

// Adds this account and saves. Will override any account with the same gmail apps url.
+ (void)addAccount:(GMAccount*)account {
	NSMutableArray* accounts = [[[self allAccounts] mutableCopy] autorelease];
	[accounts addObject:account];
	NSMutableDictionary* savableAccounts = [NSMutableDictionary dictionaryWithCapacity:[accounts count]];
	for (GMAccount* account in accounts) {
		//	TODO: refactor
		NSArray* array = [NSArray arrayWithObjects:[account gmailAppsURL], [account cookieDicts], [account accountType], nil];
		[savableAccounts setObject:array forKey:[account name]];
	}
	[[NSUserDefaults standardUserDefaults] setObject:savableAccounts forKey:accountsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteAccount:(GMAccount*)account {
	NSMutableArray* accounts = [[[self allAccounts] mutableCopy] autorelease];
	[accounts removeObject:account];
	NSMutableDictionary* savableAccounts = [NSMutableDictionary dictionaryWithCapacity:[accounts count] - 1];
	for (GMAccount* a in accounts) {
		if (![[a name] isEqualToString:[account name]]) {
			//	TODO: refactor
			NSArray* array = [NSArray arrayWithObjects:[account gmailAppsURL], [account cookieDicts], [account accountType], nil];
			[savableAccounts setObject:array forKey:[a name]];
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:savableAccounts forKey:accountsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initWithName:(NSString*)name URL:(NSString*)url accountType:(NSString*)accountType {
	if (self = [super init]) {
		_name = [name retain];
		if (nil == _name) {
			_name = [@"" retain];
		}
		_gmailAppsURL = [url retain];
		if (nil == _gmailAppsURL) {
			_gmailAppsURL = [@"" retain];
		}
		_cookieDicts = [[NSMutableArray alloc] init];
		_accountType = [accountType retain];
	}
	return self;
}

- (id)initWithName:(NSString*)name URL:(NSString*)url cookies:(NSArray*)cookies accountType:(NSString*)accountType {
	if (self = [self initWithName:name URL:url accountType:accountType]) {
		[_cookieDicts release];
		_cookieDicts = [cookies mutableCopy];
	}
	return self;
}

- (void)dealloc {
	[_name release];
	[_gmailAppsURL release];
	[_cookieDicts release];
	[_accountType release];
	[super dealloc];
}

- (NSString*)gmailAppsURL {
	return _gmailAppsURL;
}

- (NSArray*)cookieDicts {
	return _cookieDicts;
}

- (NSString*)name {
	return _name;
}

- (NSString*)accountType {
	return _accountType;
}

- (void)deleteAllCookieDicts {
	[_cookieDicts removeAllObjects];
}

- (void)addCookieDict:(NSDictionary*)dict {
	[_cookieDicts addObject:dict];
}

- (void)saveCookies {
	for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
		[self addCookieDict:[cookie properties]];
	}
	[GMAccount addAccount:self];
}

@end
