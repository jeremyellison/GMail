//
//  main.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UISpec.h>

int main(int argc, char *argv[]) {
    
	[UISpec runSpecsAfterDelay:3]; //give your app some time to load before running the specs
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"GMailAppDelegate");
    [pool release];
    return retVal;
}
