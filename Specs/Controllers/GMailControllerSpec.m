//
//  GMailControllerSpec.m
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMailControllerSpec.h"
#import "GMAccount.h"

@implementation GMailControllerSpec

- (void)beforeAll {
	app = [[UIQuery withApplication] retain];
}

-(void)afterAll {
	[app release];
}

- (void)itShouldLetMeCreateAnAccount {
	[[[app textField] placeholder:@"Display Name"] setText:@"Test Account"];
	[[[app textField] placeholder:@"Domain (e.g. twotoasters.com)"] setText:@"twotoasters.com"];
	[[[app threePartButton] title:@"Save"] touch];
	[[[[app view:@"UILabel"] text:@"Test Account"] should] exist];
}

- (void)itShouldLetMeCreateAnotherAccount {
	[[[app view:@"UIToolbarButton"] index:0] touch];
	[[[app textField] placeholder:@"Display Name"] setText:@"GMail Account"];
	[[[app textField] placeholder:@"Domain (e.g. twotoasters.com)"] setText:@"gmail.com"];
	[[[app threePartButton] title:@"Save"] touch];
	[[[[app view:@"UILabel"] text:@"GMail Account"] should] exist];
}

- (void)itShouldLetMeChoseAnAccount {
	[[[app view:@"UIToolbarButton"] index:1] touch];
	[[[[app view:@"UIThreePartButton"] title:@"GMail Account"] should] exist];
	[[[app view:@"UIThreePartButton"] title:@"Test Account"] touch];
	[[[[app view:@"UILabel"] text:@"Test Account"] should] exist];
}

- (void)itShouldLetMeDeleteAnAccount {
	[[[app view:@"UILabel"] text:@"Test Account"] touch];
	wait(1);
	[[[app view:@"UIThreePartButton"] title:@"Delete"] touch];
	[[[app view:@"UIThreePartButton"] title:@"GMail Account"] touch];
	[expectThat([[GMAccount allAccounts] count]) should:be(1)];
}

@end
