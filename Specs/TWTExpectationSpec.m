//
//  TWTExpectationSpec.m
//  Where to Watch the Match
//
//  Created by Blake Watters on 10/28/09.
//  Copyright 2009 Objective 3. All rights reserved.
//

#import "UISpec.h"
#import "TWTExpectation.h"
#import <CoreLocation/CLLocation.h>

@interface TWTExpectationSpec : NSObject <UISpec>

@end

@implementation TWTExpectationSpec

- (void)itShouldRaiseAnErrorIfNotInitializedProperly {
	NSException* raisedException = nil;
	@try {
		[expectThat(@"foo") beNil];
	}
	@catch (NSException * e) {
		raisedException = e;
	}
	[[expectThat(raisedException) shouldNot] beNil];
	[[expectThat([raisedException description]) should] equalString:@"An expectation must be initialized by calling should or shouldNot before testing an expectation"];
}

- (void)itShouldBeNil {
	[[expectThat(nil) should] meetExpectation:@selector(beNil)];
	[[expectThat(@"foo") should] failExpectation:@selector(beNil)];
	[[expectThat(nil) shouldNot] failExpectation:@selector(beNil)];
	[[expectThat(@"foo") shouldNot] meetExpectation:@selector(beNil)];
}

- (void)itShouldBeAbleToExpectTrue {
	[[expectThatBool(YES) should] meetExpectation:@selector(beTrue)];
	[[expectThatBool(NO) should] failExpectation:@selector(beTrue)];
	[[expectThatBool(YES) shouldNot] failExpectation:@selector(beTrue)];
	[[expectThatBool(NO) shouldNot] meetExpectation:@selector(beTrue)];
}

- (void)itShouldBeAbleToExpectFalse {
	[[expectThatBool(NO) should] meetExpectation:@selector(beFalse)];
	[[expectThatBool(YES) should] failExpectation:@selector(beFalse)];
	[[expectThatBool(NO) shouldNot] failExpectation:@selector(beFalse)];
	[[expectThatBool(YES) shouldNot] meetExpectation:@selector(beFalse)];
}

- (void)itShouldBeAbleToExpectEqualStrings {
	[[expectThat(@"MyString") should] meetExpectation:@selector(equalString:) withObject:@"MyString"];
	[[expectThat(@"MyString") should] failExpectation:@selector(equalString:) withObject:@"OtherString"];
	[[expectThat(@"MyString") shouldNot] failExpectation:@selector(equalString:) withObject:@"MyString"];
	[[expectThat(@"MyString") shouldNot] meetExpectation:@selector(equalString:) withObject:@"OtherString"];
	[[expectThat(nil) should] failExpectation:@selector(equalString:) withObject:@"MyString"];
}

- (void)itShouldBeAbleToExpectEqualFloats {
	[[expectThatFloat(1.2) should] meetExpectation:@selector(equalFloatValue:) withObject:[NSNumber numberWithFloat:1.2]];
	[[expectThatFloat(1.2) should] failExpectation:@selector(equalFloatValue:) withObject:[NSNumber numberWithFloat:1.3]];	
}

- (void)itShouldBeAbleToExpectEqualInts {
	[[expectThatInt(1) should] meetExpectation:@selector(equalIntValue:) withObject:[NSNumber numberWithInt:1]];
	[[expectThatInt(1) should] failExpectation:@selector(equalIntValue:) withObject:[NSNumber numberWithInt:3]];	
}

- (void)itShouldBeAbleToExpectEqualDoubles {
	double i = 2000;
	[[expectThatDouble(i) should] meetExpectation:@selector(equalDoubleValue:) withObject:[NSNumber numberWithDouble:2000]];
	[[expectThatDouble(i) should] failExpectation:@selector(equalDoubleValue:) withObject:[NSNumber numberWithDouble:1000]];
}

- (void)itShouldBeAbleToExpectEqualObjects {
	id object = [[[NSObject alloc] init] autorelease];
	[[expectThat(object) should] meetExpectation:@selector(equalObject:) withObject:object];
	[[expectThat(object) should] failExpectation:@selector(equalObject:) withObject:[[[NSObject alloc] init] autorelease]];
}

- (void)itShouldBeAbleToExpectKindOfClass {
	[[expectThat([NSString string]) should] meetExpectation:@selector(beKindOfClass:) withObject:[NSString class]];
	[[expectThat([NSString string]) should] failExpectation:@selector(beKindOfClass:) withObject:[NSArray array]];
}

- (void)itShouldBeAbleToExpectEmptyEnumerables {
	[[expectThat([NSArray array]) should] meetExpectation:@selector(beEmpty)];
	[[expectThat([NSArray arrayWithObject:@""]) should] failExpectation:@selector(beEmpty)];
}

- (void)itShouldBeAbleToExpectEqualLocations {
	CLLocation* location1 = [[CLLocation alloc] initWithLatitude:35.91189 longitude:-79.07725];
	CLLocation* location2 = [[CLLocation alloc] initWithLatitude:35.91189 longitude:-79.07725];
	CLLocation* location3 = [[CLLocation alloc] initWithLatitude:35.91014380 longitude:-79.07528950];
	[[expectThat(location1) should] meetExpectation:@selector(equalLocation:) withObject:location2];
	[[expectThat(location1) should] failExpectation:@selector(equalLocation:) withObject:location3];
}

@end
