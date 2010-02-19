//
//  GMAccount.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GMAccount : NSManagedObject {
//	NSString* _name;
//	NSString* _gmailAppsURL; //This is the key we save off of
//	NSMutableArray* _cookieDicts;
//	NSString* _accountType;
}

+ (NSArray*)accountTypes;
+ (BOOL)accountTypeRequiresAppsURL:(NSString*)accountType;
+ (NSString*)promptForURLFieldForAccountType:(NSString*)accountType;
+ (NSString*)iconForAccount:(GMAccount*)account;
+ (NSArray*)allAccounts;
+ (void)setLastAccount:(GMAccount*)account;
+ (GMAccount*)lastAccount;
+ (void)deleteAccount:(GMAccount*)account;
- (id)initWithName:(NSString*)name URL:(NSString*)url accountType:(NSString*)accountType;
- (id)initWithName:(NSString*)name URL:(NSString*)url cookies:(NSArray*)cookies accountType:(NSString*)accountType;
- (void)saveCookies;
- (void)setupCookies;
@end

@interface GMAccount (CoreDataGeneratedAccessors)

@property (nonatomic, retain) NSString * accountType;
@property (nonatomic, retain) NSData * cookieData;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * page;

@end
