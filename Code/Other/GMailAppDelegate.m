//
//  GMailAppDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "GMailAppDelegate.h"
#import "GMMailViewController.h"
#import "GMChoseAccountTypeTableViewController.h"
#import "GMCreateAccountTableViewController.h"
#import "GMAccountPickerViewController.h"
#import "GMAccount.h"

@interface GMailAppDelegate (Private)

- (void)createPersistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;

@end

@implementation GMailAppDelegate

@synthesize storeFilename = _storeFilename;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	[self setupStoreWithFilename:@"Mail.sqlite"];
	
    TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
	
	TTURLMap* map = navigator.URLMap;
	
	[map from:@"gm://mail" toSharedViewController:[GMMailViewController class]];
	[map from:@"gm://choseAccountType" toModalViewController:[GMChoseAccountTypeTableViewController class]];
	[map from:@"gm://createAccount/(initWithAccountType:)/type" toViewController:[GMCreateAccountTableViewController class]];
	[map from:@"gm://choseAccount" toModalViewController:[GMAccountPickerViewController class]];
	[map from:@"*" toViewController:[TTWebController class]];
	
	// Add your other mappings here
	
    //if (![navigator restoreViewControllers]) {
		// Put your root controller url here
		[navigator openURL:@"gm://mail" animated:NO];
	//}
	[[[TTNavigator navigator] window] makeKeyAndVisible];
}

- (void)dealloc {
	[_storeFilename release];
	[_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
	[super dealloc];
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURL:URL.absoluteString animated:NO];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self save];
}

// Core Data

- (void)setupStoreWithFilename:(NSString*)storeFilename {
	_storeFilename = [storeFilename retain];
	_managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	[self createPersistentStoreCoordinator];
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	_managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (NSError*)save {
    NSError *error;
    if (NO == [[self managedObjectContext] save:&error]) {
		return error;
    } else {
		return nil;
	}
}

- (void)createPersistentStoreCoordinator {
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:_storeFilename]];
	
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	
	// Allow inferred migration from the original version of the application.
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
    }
}

- (void)deletePersistantStore {
	NSURL* storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:_storeFilename]];
	NSError* error = nil;
	NSLog(@"Error removing persistant store: %@", [error localizedDescription]);
	if (error) {
		//Handle error
	}
	error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error];
	if (error) {
		//Handle error
	}
	[_persistentStoreCoordinator release];
	[_managedObjectContext release];
	[self createPersistentStoreCoordinator];
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	_managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
