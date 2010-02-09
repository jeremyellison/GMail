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

- (id)initWithURL:(NSString*)URL cookies:(NSArray*)cookies {
	if (self = [super init]) {
		_gmailAppsURL = [URL retain];
		_cookieDicts = [cookies mutableCopy];
		if (nil == _cookieDicts) {
			_cookieDicts = [[NSMutableArray alloc] init];
		}
	}
	return self;
}

- (void)dealloc {
	[_gmailAppsURL release];
	[_cookieDicts release];
	[super dealloc];
}

+ (NSArray*)allAccounts {
	// This is stored as a key/val store. url => cookies
	NSDictionary* accountsDict = [[NSUserDefaults standardUserDefaults] objectForKey:accountsKey];
	NSMutableArray* allAccounts = [NSMutableArray arrayWithCapacity:[[accountsDict allKeys] count]];
	for (NSString* key in [accountsDict allKeys]) {
		GMAccount* account = [[[self alloc] initWithURL:key cookies:[accountsDict objectForKey:key]] autorelease];
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
		[savableAccounts setObject:[account cookieDicts] forKey:[account gmailAppsURL]];
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

- (void)deleteAllCookieDicts {
	[_cookieDicts removeAllObjects];
}

- (void)addCookieDict:(NSDictionary*)dict {
	[_cookieDicts addObject:dict];
}

@end
