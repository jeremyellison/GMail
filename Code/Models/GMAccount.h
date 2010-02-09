//
//  GMAccount.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMAccount : NSObject {
	NSString* _gmailAppsURL; //This is the key we save off of
	NSMutableArray* _cookieDicts;
}

- (id)initWithURL:(NSString*)URL cookies:(NSArray*)cookies;

// All currently saved accounts
+ (NSArray*)allAccounts;

// Adds this account and saves. Will override any account with the same gmail apps url.
+ (void)addAccount:(GMAccount*)account;

- (NSString*)gmailAppsURL;

- (NSArray*)cookieDicts;

- (void)deleteAllCookieDicts;

- (void)addCookieDict:(NSDictionary*)dict;

@end
