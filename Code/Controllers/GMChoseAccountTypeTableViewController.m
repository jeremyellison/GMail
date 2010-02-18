//
//  GMChoseAccountTypeTableViewController.m
//  GMail
//
//  Created by Jeremy Ellison on 2/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GMChoseAccountTypeTableViewController.h"
#import "GMAccount.h"

@implementation GMChoseAccountTypeTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)loadView {
	[super loadView];
	self.title = @"Add Account";
}

- (void)createModel {
	NSMutableArray* items = [NSMutableArray arrayWithCapacity:[[GMAccount accountTypes] count]];
	for (NSString* type in [GMAccount accountTypes]) {
		[items addObject:[TTTableTextItem itemWithText:type
												   URL:[NSString stringWithFormat:@"gm://createAccount/%@/type", [type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
	}
	self.dataSource = [TTListDataSource dataSourceWithItems:items];
}

@end
