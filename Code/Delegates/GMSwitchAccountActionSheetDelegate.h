//
//  GMSwitchAccountActionSheetDelegate.h
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMDelegate.h"


@interface GMSwitchAccountActionSheetDelegate : GMDelegate <UIActionSheetDelegate> {
	NSArray* _accounts;
}

@property (nonatomic, retain) NSArray* accounts;

@end
