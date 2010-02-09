//
//  GMailAppDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "GMailAppDelegate.h"
#import "GMMailViewController.h"

@implementation GMailAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
    TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
	
	TTURLMap* map = navigator.URLMap;
	
	[map from:@"gm://mail" toSharedViewController:[GMMailViewController class]];
	[map from:@"*" toViewController:[TTWebController class]];
	
	// Add your other mappings here
	
    //if (![navigator restoreViewControllers]) {
		// Put your root controller url here
		[navigator openURL:@"gm://mail" animated:NO];
	//}
	[[[TTNavigator navigator] window] makeKeyAndVisible];
}

- (void)dealloc {
	[super dealloc];
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURL:URL.absoluteString animated:NO];
	return YES;
}

@end
