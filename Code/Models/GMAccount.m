//
//  GMAccount.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMAccount.h"
#import <CoreData/CoreData.h>
#import "GMailAppDelegate.h"

@interface GMAccount (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveUrl;
- (void)setPrimitiveUrl:(NSString *)value;

@end

@implementation GMAccount (CoreDataGeneratedAccessors)

@dynamic accountType;
@dynamic cookieData;
@dynamic name;
@dynamic url;
@dynamic order;
@dynamic page;

@end

@implementation GMAccount

//static NSString* accountsKey = @"kGMailAccountsKey";
static NSString* lastAccountKey = @"kGMailLastAccountKey";

+ (NSArray*)accountTypes {
	return [NSArray arrayWithObjects:@"Google Apps", @"GMail", @"Yahoo! Mail", @"Hotmail", @"Custom", nil];
}

+ (BOOL)accountTypeRequiresAppsURL:(NSString*)accountType {
	return [accountType isEqualToString:@"Google Apps"] || 
			[accountType isEqualToString:@"Custom"];
}

+ (NSString*)domainForAccountType:(NSString*)accountType {
	return [[NSDictionary dictionaryWithObjectsAndKeys:
			 @"http://mail.google.com/a/", @"Google Apps",
			 @"http://mail.google.com/", @"GMail",
			 @"http://m.yahoo.com/mail/", @"Yahoo! Mail",
			 @"http://hotmail.com/", @"Hotmail",
			 @"", @"Custom", nil] objectForKey:accountType];
}

+ (NSString*)promptForURLFieldForAccountType:(NSString*)accountType {
	if ([accountType isEqualToString:@"Google Apps"]) {
		return @"Domain";
	}
	return @"URL";
}

+ (NSString*)iconForAccount:(GMAccount*)account {
	return [[NSDictionary dictionaryWithObjectsAndKeys:
			 @"bundle://gmail-blue.png", @"Google Apps",
			 @"bundle://gmail-red.png", @"GMail",
			 @"bundle://yahoo.png", @"Yahoo! Mail",
			 @"bundle://msn.png", @"Hotmail",
			 @"bundle://default.png", @"Custom", nil] objectForKey:account.accountType];
}

+ (NSArray*)allAccounts {
	NSManagedObjectContext* context = [(GMailAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[NSEntityDescription entityForName:@"GMAccount" inManagedObjectContext:context]];
	NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
							  
	NSError* error = nil;
	NSArray* accounts = [context executeFetchRequest:request error:&error];
	//TODO: check error
	return accounts;
}

+ (void)setLastAccount:(GMAccount*)account {
	[[NSUserDefaults standardUserDefaults] setObject:[account name] forKey:lastAccountKey];
}

+ (GMAccount*)lastAccount {
	NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:lastAccountKey];
	NSManagedObjectContext* context = [(GMailAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[NSEntityDescription entityForName:@"GMAccount" inManagedObjectContext:context]];
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	[request setPredicate:predicate];
	[request setFetchLimit:1];
	NSError* error = nil;
	NSArray* results = [context executeFetchRequest:request error:&error];
	// TODO: check error
	if ([results count] > 0) {
		return [results objectAtIndex:0];
	}
	return nil;
}

+ (void)deleteAccount:(GMAccount*)account {
	NSManagedObjectContext* context = [(GMailAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	[context deleteObject:account];
}

- (id)initWithName:(NSString*)name URL:(NSString*)url accountType:(NSString*)accountType {
	NSManagedObjectContext* context = [(GMailAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription* entity = [NSEntityDescription entityForName:@"GMAccount" inManagedObjectContext:context];
	if (self = [self initWithEntity:entity insertIntoManagedObjectContext:context]) {
		self.name = name;
		self.accountType = accountType;
		// have to set url after account type.
		self.url = url;
		self.cookieData = nil;
		int order = [[GMAccount allAccounts] count] - 1;
		int page = order / 16;
		self.order = [NSNumber numberWithInt:order];
		self.page = [NSNumber numberWithInt:page];
	}
	return self;
}

- (id)initWithName:(NSString*)name URL:(NSString*)url cookies:(NSArray*)cookies accountType:(NSString*)accountType {
	if (self = [self initWithName:name URL:url accountType:accountType]) {
		NSData* data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
		self.cookieData = data;
	}
	return self;
}

- (void)saveCookies {
	self.cookieData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
}

- (void)setupCookies {
	NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie* cookie in [cookieStorage cookies]) {
		[cookieStorage deleteCookie:cookie];
	}
	NSArray* cookies = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:self.cookieData];
	for (NSHTTPCookie* cookie in cookies) {
		[cookieStorage setCookie:cookie];
	}
}

- (void)setUrl:(NSString *)value {
	NSString* newURL;
	if ([GMAccount accountTypeRequiresAppsURL:self.accountType]) {
		newURL = [NSString stringWithFormat:@"%@%@", [GMAccount domainForAccountType:self.accountType], value];
	} else {
		newURL = [GMAccount domainForAccountType:self.accountType];
	}
    [self willChangeValueForKey:@"url"];
    [self setPrimitiveUrl:newURL];
    [self didChangeValueForKey:@"url"];
}

@end

