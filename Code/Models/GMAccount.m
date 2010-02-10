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

- (id)initWithName:(NSString*)name URL:(NSString*)url {
	if (self = [super init]) {
		_name = [name retain];
		_gmailAppsURL = [url retain];
		_cookieDicts = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithName:(NSString*)name URL:(NSString*)url cookies:(NSArray*)cookies {
	if (self = [self initWithName:name URL:url]) {
		[_cookieDicts release];
		_cookieDicts = [cookies mutableCopy];
	}
	return self;
}

//- (id)initWithURL:(NSString*)URL cookies:(NSArray*)cookies {
//	if (self = [super init]) {
//		_gmailAppsURL = [URL retain];
//		_cookieDicts = [cookies mutableCopy];
//		if (nil == _cookieDicts) {
//			_cookieDicts = [[NSMutableArray alloc] init];
//		}
//	}
//	return self;
//}

- (void)dealloc {
	[_name release];
	[_gmailAppsURL release];
	[_cookieDicts release];
	[super dealloc];
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
		GMAccount* account = [[[self alloc] initWithName:key URL:[array objectAtIndex:0] cookies:[array objectAtIndex:1]] autorelease];
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
		NSArray* array = [NSArray arrayWithObjects:[account gmailAppsURL], [account cookieDicts], nil];
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
			NSArray* array = [NSArray arrayWithObjects:[account gmailAppsURL], [account cookieDicts], nil];
			[savableAccounts setObject:array forKey:[a name]];
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:savableAccounts forKey:accountsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
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

- (void)deleteAllCookieDicts {
	[_cookieDicts removeAllObjects];
}

- (void)addCookieDict:(NSDictionary*)dict {
	[_cookieDicts addObject:dict];
}

@end
