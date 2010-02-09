//
//  TWTExpectation.h
//  Where to Watch the Match
//
//  Created by Blake Watters on 10/28/09.
//  Copyright 2009 Objective 3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define expectThat(object) [TWTExpectation expectationWithObject:object file:__FILE__ line:__LINE__]
#define expectThatBool(bool) [TWTExpectation expectationWithObject:[NSNumber numberWithBool:bool] file:__FILE__ line:__LINE__]
#define expectThatFloat(float) [TWTExpectation expectationWithObject:[NSNumber numberWithFloat:float] file:__FILE__ line:__LINE__]
#define expectThatInt(int) [TWTExpectation expectationWithObject:[NSNumber numberWithInt:int] file:__FILE__ line:__LINE__]
#define expectThatDouble(double) [TWTExpectation expectationWithObject:[NSNumber numberWithDouble:double] file:__FILE__ line:__LINE__]

@interface TWTExpectation : NSObject {
	id _object;
	char* _file;
	int _line;	
	BOOL _expectedValue;
	BOOL _initialized;
}

/**
 * Build an expectation object ready for testing
 */
+ (TWTExpectation*)expectationWithObject:(id)object file:(char*)file line:(int)line;

/**
 * Initialize and return an expectation object
 */
- (id)initWithObject:(id)object file:(char*)file line:(int)line;

/**
 * Specifies that the expectation should be met
 */
- (TWTExpectation*)should;

/**
 * Specifies that the expectation should not be met
 */
- (TWTExpectation*)shouldNot;

/**********
 * Expectation primitives
 */

/**
 * Assert that the evaluated expectation should be true
 */
- (void)beTrue;

/**
 * Assert that the evaluated expectation should be false
 */
- (void)beFalse;

/**
 * Assert that the evaluated expectation should be equal to nil
 */
- (void)beNil;

/**
 * Asserts that the count of the object is 0
 */
- (void)beEmpty;

/**
 * Assert that the evaluated expectation should be equal to the specified string
 */
- (void)equalString:(NSString*)string;

/**
 * Assert that the evaluated expectation should be equal to the float value of the number
 */
- (void)equalFloatValue:(NSNumber*)number;

/**
 * Assert that evaluated expectation should be equal to the int value of the number
 */
- (void)equalIntValue:(NSNumber*)number;

/**
 * Assert that evaluated expectation should be equal to the double value of the number
 */
- (void)equalDoubleValue:(NSNumber*)number;

/**
 * Assert that evaluated expectation should be equal to the object passed in
 */
- (void)equalObject:(id)object;

/**
 * Assert that the distance between two locations is 0
 */
- (void)equalLocation:(CLLocation*)location;

/**********
 * Expectation wrappers
 *
 * These methods are used to spec the expectations themselves or build higher order 
 * expectations around the primitives above.
 */

- (void)meetExpectation:(SEL)selector;
- (void)meetExpectation:(SEL)selector withObject:(id)object;
- (void)failExpectation:(SEL)selector;
- (void)failExpectation:(SEL)selector withObject:(id)object;

@end
