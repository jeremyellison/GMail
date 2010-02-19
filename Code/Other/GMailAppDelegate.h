//
//  GMailAppDelegate.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <Three20/Three20.h>
#import <CoreData/CoreData.h>

@interface GMailAppDelegate : NSObject <UIApplicationDelegate> {
	NSString* _storeFilename;
	NSManagedObjectModel* _managedObjectModel;
	NSPersistentStoreCoordinator* _persistentStoreCoordinator;
    NSManagedObjectContext* _managedObjectContext;
}

@property (nonatomic, readonly) NSString* storeFilename;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 * Initialize a new managed object store with a SQLite database with the filename specified
 */
- (void)setupStoreWithFilename:(NSString*)storeFilename;

/**
 * Save the current contents of the managed object store
 */
- (NSError*)save;

/**
 * This deletes and recreates the managed object context and 
 * persistant store, effectively clearing all data
 */
- (void)deletePersistantStore;

@end

