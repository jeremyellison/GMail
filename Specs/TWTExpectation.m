//
//  TWTExpectation.m
//  Where to Watch the Match
//
//  Created by Blake Watters on 10/28/09.
//  Copyright 2009 Objective 3. All rights reserved.
//

#import "TWTExpectation.h"

@implementation TWTExpectation

+ (id)expectationWithObject:(id)object file:(char*)file line:(int)line {
	return [[[TWTExpectation alloc] initWithObject:object file:file line:line] autorelease];
}

- (id)initWithObject:(id)object file:(char*)file line:(int)line {
	if (self = [super init]) {
		_object = [object retain];
		_file = file;
		_line = line;
		_initialized = NO;
	}
	return self;
}

- (void)dealloc {
	[_object release];
	[super dealloc];
}

- (NSString*) description {
	return [NSString stringWithFormat:@"Expectation: (_object: %@ [%@])", _object, NSStringFromClass([_object class])];
}

- (void)failWithMessage:(NSString*)format, ... {
	va_list args;
    va_start(args, format);
    NSString *message = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    va_end(args);
	[NSException raise:nil format:@"%@ [%s:%d]", message, _file, _line];
}

- (TWTExpectation*)should {
	_expectedValue = YES;
	_initialized = YES;
	return self;
}

- (TWTExpectation*)shouldNot {
	_expectedValue = NO;
	_initialized = YES;
	return self;
}

- (void)checkExpectation:(BOOL)value message:(NSString*)message negativeMessage:(NSString*)negativeMessage, ... {
	if (!_initialized) {
		[NSException raise:nil format:@"An expectation must be initialized by calling should or shouldNot before testing an expectation"];
	}
	if (value != _expectedValue) {
		va_list args;
		va_start(args, negativeMessage);
		NSString* formatString = (_expectedValue == YES) ? message : negativeMessage;
		NSString* error = [[[NSString alloc] initWithFormat:formatString arguments:args] autorelease];
		va_end(args);
		[NSException raise:nil format:@"%@ [%s:%d]", error, _file, _line];
	}
}

- (void)beNil {
	[self checkExpectation:(nil == _object)
				   message:@"Expected object %@ to equal nil, but did not"
		   negativeMessage:@"Expected object %@ NOT to equal nil, but it did", _object];
}

- (void)beTrue {
	[self checkExpectation:(YES == [_object boolValue])
				   message:@"Expected object %@ to be TRUE, but it was not"
		   negativeMessage:@"Expected object %@ NOT to be TRUE, but it was", _object];
}

- (void)beFalse {
	[self checkExpectation:(NO == [_object boolValue])
				   message:@"Expected object %@ to be TRUE, but it was not"
		   negativeMessage:@"Expected object %@ NOT to be TRUE, but it was", _object];
}

- (void)equalString:(NSString*)string {
	[self checkExpectation:([_object isEqualToString:string])
				   message:@"Expected '%@' to equal '%@' but it did not"
		   negativeMessage:@"Expected '%@' NOT to equal '%@' but it did", _object, string];
}

- (void)equalFloatValue:(NSNumber*)number {
	[self checkExpectation:([_object floatValue] == [number floatValue])
				   message:@"Expected '%@' to equal '%@' but it did not"
		   negativeMessage:@"Expected '%@' NOT to equal '%@' but it did", _object, number];
}

- (void)equalIntValue:(NSNumber*)number {
	[self checkExpectation:([_object intValue] == [number intValue])
				   message:@"Expected '%@' to equal '%@' but it did not"
		   negativeMessage:@"Expected '%@' NOT to equal '%@' but it did", _object, number];
}

- (void)equalDoubleValue:(NSNumber*)number {
	[self checkExpectation:([_object doubleValue] == [number doubleValue])
				   message:@"Expected '%@' to equal '%@' but it did not"
		   negativeMessage:@"Expected '%@' NOT to equal '%@' but it did", _object, number];
}

- (void)equalObject:(id)object {
	[self checkExpectation:(_object == object)
				   message:@"Expected '%@' to equal '%@' but it did not"
		   negativeMessage:@"Expected '%@' NOT to equal '%@' but it did", _object, object];
}

- (void)beKindOfClass:(Class)class {
	[self checkExpectation:([_object isKindOfClass:class])
				   message:@"Expected '%@' to be kind of class '%@' but it was not"
		   negativeMessage:@"Expected '%@' NOT to be kind of class '%@' but it was", _object, class];
}

- (void)beEmpty {
	[self checkExpectation:([_object count] == 0)
				   message:@"Expected '%@' to be empty, but it was not"
		   negativeMessage:@"Expected '%@' NOT to be empty, but it was", _object];
}

- (void)equalLocation:(CLLocation*)location {
	[self checkExpectation:(0 == [_object getDistanceFrom:location])
				   message:@"Expected '%@' to be at the same location as '%@' but it wasn't"
		   negativeMessage:@"Expected '%@' NOT be at the same location as '%@' but it was", _object, location];
	
}

// Meta Expectations

- (void)expect:(SEL)expectationSelector toPass:(BOOL)expectingExpectationToPass withObject:(id)object{
	NSString* message;
	if (expectingExpectationToPass) {
		if (nil == object) {
			message = @"Expected object %@ to meet expectation %@, but it did NOT";
		} else {
			message = @"Expected object %@ to meet expectation %@ with object %@, but it did NOT";
		}
	} else {
		if (nil == object) {
			message = @"Expected object %@ NOT to meet expectation %@, but it did";
		} else {
			message = @"Expected object %@ NOT to meet expectation %@ with object %@, but it did";
		}
	}
	NSString* selectorName = NSStringFromSelector(expectationSelector);
	BOOL passed = YES;
	@try {
		[self performSelector:expectationSelector withObject:object];
	}
	@catch (NSException * e) {
		passed = NO;
	}
	@finally {
		if (passed != expectingExpectationToPass) {
			[self failWithMessage:message, self, selectorName, object];
		}
	}	
}

- (void)meetExpectation:(SEL)expectationSelector {
	[self expect:expectationSelector toPass:YES withObject:nil];
}

- (void)meetExpectation:(SEL)expectationSelector withObject:(id)object {
	[self expect:expectationSelector toPass:YES withObject:object];
}

- (void)failExpectation:(SEL)expectationSelector {
	[self expect:expectationSelector toPass:NO withObject:nil];
}

- (void)failExpectation:(SEL)expectationSelector withObject:(id)object {
	[self expect:expectationSelector toPass:NO withObject:object];
}

@end
