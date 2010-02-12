//
//  GMDocumentLoader.m
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMDocumentLoader.h"
#import <Three20/Three20.h>

@implementation GMDocumentLoader

- (id)initWithDocumentURL:(NSURL*)url webView:(UIWebView*)webView {
	if (self = [super init]) {
		_url = [url retain];
		_webView = [webView retain];
		_loading = NO;
		_data = [[NSMutableData alloc] init];
		_request = [[NSMutableURLRequest alloc] initWithURL:_url];
		_connection = nil;
		_mimeType = nil;
	}
	return self;
}

- (void)dealloc {
	[_connection cancel];
	[_connection release];
	[_request release];
	[_data release];
	[_webView release];
	[_url release];
	[_mimeType release];
	[_response release];
	[super dealloc];
}

+ (id)loadDocumentAtURL:(NSURL*)url intoWebView:(UIWebView*)webView {
	GMDocumentLoader* loader = [[GMDocumentLoader alloc] initWithDocumentURL:url webView:webView];
	[loader loadDocument];
	return loader;
}

- (void)loadDocument {
	NSLog(@"Loading Document: %@", _url);
	_connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
	[_connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", response);
	_response = [response retain];
	_mimeType = [[response MIMEType] retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"MimeType: %@", _mimeType);
	if ([_response statusCode] == 200) {
		[_webView loadData:_data MIMEType:[_response MIMEType] textEncodingName:[_response textEncodingName] baseURL:[[_request URL] baseURL]];
	} else {
		TTAlert(@"Error loading document");
	}
	
	[self release];
}

@end
