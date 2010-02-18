//
//  GMAccount.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMAccount : NSObject {
	NSString* _name;
	NSString* _gmailAppsURL; //This is the key we save off of
	NSMutableArray* _cookieDicts;
	NSString* _accountType;
}

+ (NSArray*)accountTypes;
+ (BOOL)accountTypeRequiresAppsURL:(NSString*)accountType;

- (id)initWithName:(NSString*)name URL:(NSString*)url accountType:(NSString*)accountType;

- (id)initWithName:(NSString*)name URL:(NSString*)url cookies:(NSArray*)cookies accountType:(NSString*)accountType;

//- (id)initWithURL:(NSString*)URL cookies:(NSArray*)cookies;

// All currently saved accounts
+ (NSArray*)allAccounts;

// Adds this account and saves. Will override any account with the same gmail apps url.
+ (void)addAccount:(GMAccount*)account;

+ (void)deleteAccount:(GMAccount*)account;

+ (GMAccount*)lastAccount;

+ (void)setLastAccount:(GMAccount*)account;

- (NSString*)gmailAppsURL;

- (NSArray*)cookieDicts;

- (NSString*)name;

- (NSString*)accountType;

- (NSString*)url;

- (void)deleteAllCookieDicts;

- (void)addCookieDict:(NSDictionary*)dict;

// Saves cookies currently in NSCookieStorage sharedCookieStorage, but does not remove any other stored cookies.
- (void)saveCookies;

@end
